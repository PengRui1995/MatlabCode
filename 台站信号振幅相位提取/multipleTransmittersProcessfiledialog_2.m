% %% 本函数，只对一个数据文件进行处理
% clc;
%clear all;
% close all;
%fc,channel,fcuts,
%% 
clc
clear
%fc=19800;%NWC
%fc=30000;
fc=22200;%JJI
%fc=24100;
%fc=18200;
%fc=21100;
%fc=16400;
%fc=23400;
%fc=21400;
%fc=40000;
%fc=38400;
%% 参数声明
[FileName,PathName] = uigetfile('*.cos','请选择一个数据','E:\VLF_data\');
if isequal(FileName,0)                  %没有选择数据
    return;
end

[file_id,message] = fopen([PathName,FileName],'rb');
if file_id < 0      %打开错误
   disp(message);
end
Rawdatas = fread(file_id,'uint16'); %按数据存储方式读取
Rawdatas = Rawdatas';               %对数据转置
fclose(file_id);    %16bits长度，即数据长度  

%% 判断单通道还是双通道
if(strcmp(FileName(1:4),'EWNS'))
    j = 1;
    L = length(Rawdatas);
    EWdata = zeros(1,L/2);
    NSdata = zeros(1,L/2);
    for i=1:2:L
        EWdata(j) = Rawdatas(i);
        NSdata(j) = Rawdatas(i+1);
        j = j+1;
    end
    A = NSdata;%选取一个通道，或A = EWdata
    B = EWdata;
end

%%
%A = NSdata(1:250000);%选取一个通道，或A = EWdata
A = EWdata(1:250000);
DataL = length(A);
fs=250000;

%% 带通滤波器设计中心频率fc,带宽2000hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcuts = [fc-2000 fc-500 fc+500 fc+2000];%[fc-500 fc-180 fc+180 fc+500]+100;%[fc-500 fc-180 fc+180 fc+500];%[fc-1000 fc-300 fc+300 fc+1000];
Ap = 1;
As = 50;     % 定义通带及阻带衰减
devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; % 计算偏移量
mags = [0 1 0];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
h_LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = filtfilt(h_LP,1,A);      %零相位滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%
fn = 250000;            %每秒总采样点数
dt = 1/fs;
tend = DataL/fs;        %时间 
msk_data = data(1:fn*tend);
% tn  = start_time:dt:start_time+tend-dt;
tn  = 0:dt:tend-dt;%tn=(0:DataL-1)*dt    采样时间序列
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         利用软件DDS 生成理想的频率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [sin_osci,cos_osci, tn] = dds_generate(fc, fs, Bits, 10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MSK数字带通解调仿真
%   正交 相干 解调
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id = msk_data.*cos(2*pi*fc*tn);           %同相支路 2*pi*fc=Wc
Qd = msk_data.*cos(2*pi*fc*tn+pi/2);        %正交支路
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FIR滤波器 降采样时的抗混叠滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcut_lp = [fc+3000 fc+6000];
Ap=1;
As=50;   	
devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];	
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs);
LP_anti = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_anti = filtfilt(LP_anti,1,Id);        %filter data
Qd_anti = filtfilt(LP_anti,1,Qd);        %filter data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        resample   DeCIC rate = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
down_sample_rate = 10;
Id_D = Id_anti(1:down_sample_rate:end);
Qd_D = Qd_anti(1:down_sample_rate:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    获得基带滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIR滤波器
fcut_lp = [220 400];
Ap=1;
As=50;    
devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; 
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs/down_sample_rate);
LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_fiter = filtfilt(LP,1,Id_D);  %信号通过滤波器
Qd_fiter = filtfilt(LP,1,Qd_D);  %信号通过滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   相对于200HZ波特率而言，降采样至1000HZ仍是过采样
%   resample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rate_d = 5;
Id_after_d = Id_fiter(1:rate_d:end);
Qd_after_d = Qd_fiter(1:rate_d:end);

%tp = tn(1:rate_d*down_sample_rate:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       求解相位与幅度
%       相位变化范围：-180deg~+180deg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amp = Id_after_d.^2 + Qd_after_d.^2;
amp_s = 2*sqrt(amp);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


base_c = Id_after_d+sqrt(-1)*Qd_after_d;
base_c = base_c.*base_c;

base_cfft=fftshift(fft(base_c));
phase=angle(base_cfft(fs/down_sample_rate/rate_d/2-99))*180/pi;
amp=mean(amp_s);
figure;plot(20*log10(abs(base_cfft)),'-o');%hold on;plot(magI);
title(FileName);

%% 输出幅度相位
% amp1=mean(amp_deal);
% N=length(base_c);%fft点数
% fs2=fn_d;
% point=round([100/(fs2/N)+1 N-100/(fs2/N)+1]);%点
% fftamp=sqrt(abs(base_cfft(point))/2/pi);
% fftphase=angle(base_cfft(point));
% disp(amp1);disp(fftamp);disp(fftphase);
%figure;plot(abs(fft(msk_data(1:250000))),'-o')
%% 
% testc=Id_after_d+sqrt(-1)*Qd_after_d;
% magtestc=20*log(abs(fftshift(fft(testc))));
% figure;plot(magtestc);

% testc=Id_after_d+sqrt(-1)*Qd_after_d;
% magtestc=20*log(abs(fft(testc)));
% figure;plot(magtestc);