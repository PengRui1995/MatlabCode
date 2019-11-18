function [phase_seq amp_seq]=fnExtPhaseAmpSeq(data,fc,fs)
%ExtPhaseAmpSeq=Extraction of Phase Amplitude Sequence提取相位振幅列
%输入：
%输出：phase_seq相位列，amp_seq振幅列
%
%% 带通滤波器设计中心频率fc,带宽1000hz
fcuts=[fc-500,fc-100,fc+100,fc+500];    %定义通带和阻带衰减
Ap=1;        
As=50;
mags=[0 1 0];%0->1 表示带阻变带通 ，反之亦是
%计算偏移量
devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];
%devs=用于指定各个频带输出滤波器的频率响应与其期望幅值之间的最大输出误差或偏差
%通带纹波是指在滤波器的频响中通带的最大幅值和最小幅值之间的差值，正常的纹波一般小于1db。不过也视情况而言，通带纹波会导致通带内的幅值大小有变化，一般要求越高，纹波越小越好。通带纹波和滤波器的阶数有关系，阶数越大纹波越小。
%阻带衰减：在通带中，有部分信号通，部分信号阻，而阻的部分不能不能全部阻断，只有部分衰减，部分留了下来，最小衰减描述了阻碍受阻信号的能力，衰减越大，则能力越好。
[n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
data=filtfilt(hh,1,data);%零相位滤波器
%% 得到I(t)和Q(t)信号
dataL=length(data);
fn=250000;%总采样率
dt=1/fs;
tend=dataL/fs;
Msk_Date=data(1:fn*tend);
tn=(0:dataL-1)*dt;%采样时间序列
%********************************
Id=Msk_Date.*cos(2*pi*fc*tn);       %同相支路
Qd=Msk_Date.*cos(2*pi*fc*tn+pi/2);  %正交支路
%********************************
%%  FIR滤波器 降采样时的抗混叠滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcut_lp=[fc+2000 fc+4000];
Ap=1;
As=50;
devs=[10^(Ap/20-1)/10^(Ap/20+1),10^(-As/20)];
mags=[1 0];%低通滤波
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs);
lp_anti=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_anti=filtfilt(lp_anti,1,Id);
Qd_anti=filtfilt(lp_anti,1,Qd);
%% 降采样1倍
down_sample_rate=1;
Id_data=Id_anti(1:down_sample_rate:end);
Qd_data=Qd_anti(1:down_sample_rate:end);
%% 获得基带滤波器,低通滤波器
fcut=[300 450] ;
Ap=1;
As=50;
devs=[10^(Ap/20-1)/10^(As/20+1),10^(-As/20)];
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut,mags,devs,fs/down_sample_rate);
lp=fir1(n,Wn,kaiser(n+1,beta),'noscale');
%% 通过滤波器
Id_after=filtfilt(lp,1,Id_data);
Qd_after=filtfilt(lp,1,Qd_data);
%% 继续降采样
down_rate=1;
id=Id_after(1:down_rate:end);
qd=Qd_after(1:down_rate:end);
%% 求解相位与振幅
%振幅（amplitude）
temp_amp=id.^2+qd.^2;
amp_seq=2*sqrt(temp_amp);
%amp_s = 20*log(5*amp_s/65535);
  %构造基波
base=id+1i*qd;
phase_seq=unwrap(angle(base));
%% 求出基波频域并求相位

%fft快速傅里叶变换
%phase相位
% base_fft=fftshift(fft(base));
% amp=mean(amp_s);
% phase=angle(base_fft(fs/down_sample_rate/down_rate/2-round(fb/2-1)))*180/pi;
%plot(phase,'-o');
% xlabel('频率/HZ');
% ylabel('角度/o');
%figure;plot(20*log10(abs(base_fft)),'-o');
end