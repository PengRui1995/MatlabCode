function [amp,phase]=myvlfMSKDemodulation4(fs,fc,fb,A)
%此文件中采用PR的序列，全延迟gpd滤波
%更改了滤波器参数，滤波器阶数降低，运算速度增加，使用filter进行滤波

%fs:采样率
%fc:台站信号频率
%fb:MSK调制 波特率 Baud rate，区别于比特率
%A:待处理的数据
%phase:2*phi
%amp:输出的amp值，单位与A相同。

DataL = length(A);

%% 带通滤波器设计中心频率fc,带宽2000hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
h_LP=load('H_1.txt');
%%%%%%
% fcuts = [fc-2000 fc-500 fc+500 fc+2000];
% Ap = 1;
% As = 50;     % 定义通带及阻带衰减
% devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; % 计算偏移量
% mags = [0 1 0];
% [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
% h_LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d1=ceil(mean(grpdelay(h_LP,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data=filter(h_LP,1,[A zeros(1,d1)]);
data=data(d1+1:end);
% data = filtfilt(h_LP,1,A);      %零相位滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% 获取IQ信号
msk_data = data;
dt = 1/fs;
tend = DataL/fs;        %时间 
% tn  = start_time:dt:start_time+tend-dt;
tn  = 0:dt:tend-dt;

Id = msk_data.*cos(2*pi*fc*tn);           %同相支路
Qd = msk_data.*cos(2*pi*fc*tn+pi/2);        %正交支路
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FIR滤波器 降采样时的抗混叠滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
LP_anti=load('H_2.txt');
%%%%%%
% fcut_lp = [fc+3000 fc+6000];
% Ap=1;
% As=50;   	
% devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];	
% mags=[1 0];
% [n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs);
% LP_anti = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d2=ceil(mean(grpdelay(LP_anti,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_anti=filter(LP_anti,1,[Id zeros(1,d2)]);
Id_anti=Id_anti(d2+1:end);
Qd_anti=filter(LP_anti,1,[Qd zeros(1,d2)]);
Qd_anti=Qd_anti(d2+1:end);
%  Id_anti = filtfilt(LP_anti,1,Id);        %filter data
%  Qd_anti = filtfilt(LP_anti,1,Qd);        %filter data
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
%%%%%
LP=load('H_3.txt');
%%%%%
% fcut_lp = [220 400];
% Ap=1;
% As=50;    
% devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; 
% mags=[1 0];
% [n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs/down_sample_rate);
% LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d3=ceil(mean(grpdelay(LP,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_fiter=filter(LP,1,[Id_D zeros(1,d3)]);
Id_fiter=Id_fiter(d3+1:end);
Qd_fiter=filter(LP,1,[Qd_D zeros(1,d3)]);
Qd_fiter=Qd_fiter(d3+1:end);
%  Id_fiter = filtfilt(LP,1,Id_D);  %信号通过滤波器
%  Qd_fiter = filtfilt(LP,1,Qd_D);  %信号通过滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   相对于200HZ波特率而言，降采样至1000HZ仍是过采样
%   resample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rate_d = 5;
Id_after_d = Id_fiter(1:rate_d:end);
Qd_after_d = Qd_fiter(1:rate_d:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       求解相位与幅度
%       相位变化范围：-180deg~+180deg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amp_s = 2*sqrt(Id_after_d.^2 + Qd_after_d.^2);
amp=mean(amp_s);

base_c = Id_after_d+sqrt(-1)*Qd_after_d;
base_c = base_c.*base_c;
ftB = fftshift(fft(base_c));
phase=angle(ftB(fs/down_sample_rate/rate_d/2-99))*180/pi;
end