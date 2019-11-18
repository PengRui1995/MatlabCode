function wave=fnGetSFS(data,fs,fc)
% data 原始数据，各种频率混合
% fc  单频信号波形
% fs  采样率
  %% 设计带通滤波器,提取fc的信号
%         fs = 250000; % 采样率
%         fc =22200;%中心频率
        fcuts=[fc-500 fc-100 fc+100 fc+500];
        Ap=1;
        As=40;% 定义通带及阻带衰减
        devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% 计算偏移量
        mags=[0 1 0];
        [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
        h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
        %% 零相位滤波
        wave=filtfilt(h,1,data);    
end