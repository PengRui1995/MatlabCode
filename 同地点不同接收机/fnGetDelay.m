function [delay1,delay2,val,val2]=fnGetDelay(Far,Near,fs,fc)

    %% 设计带通滤波器,提取fc=22200HZ的信号
    fs = 250000; % 采样率
    fc =22200;%中心频率
    fcuts=[fc-500 fc-100 fc+100 fc+500];
    Ap=1;
    As=50;% 定义通带及阻带衰减
    devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% 计算偏移量
    mags=[0 1 0];
    [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
    h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%     %% 滤波
     FarSta=Far;
    NearSta = Near;
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% 
    [c,lags]=xcorr(fdata(1:fs),ndata(1:fs),'coeff');
    [val,ind]=max(c);
    [val2,ind2]=min(c);
    figure
    plot(lags,c,'-o');
    delay1=lags(ind);
    delay2 =lags(ind2);

end