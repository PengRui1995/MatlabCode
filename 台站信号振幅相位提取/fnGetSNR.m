function SNR=fnGetSNR(Sdata,fs,fc)
% sdata指源数据
% fs采样率，fc中心频率

%Sdata=Sdata(1:250000);
%% 带通滤波器设计300Hz-50000kHZ
%fs = 250000; % 采样率
fcuts=[300 500 50000 51000];
Ap=1;
As=40;% 定义通带及阻带衰减
devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% 计算偏移量
mags=[0 1 0];
[n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
h_LP=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
data=filtfilt(h_LP,1,Sdata);%零相位滤波器

DataL=length(data);
%% 基于FFT谱处理
NFFT =2048*1;  %FFT点数控制
h = hamming(NFFT);  %加窗，减少频谱泄漏
h = h';
DataL=length(data);
SegNum = floor(DataL/NFFT);     %包含的数据段数
dt = 1/fs*NFFT;     %每段时间间隔
DataFFT = zeros(NFFT,SegNum);
DataFre = zeros(NFFT/2,SegNum);
for i1 = 1:SegNum %数据分段读出
    DataFFT(:,i1) = fft(h.*data(1+NFFT*(i1-1):NFFT*i1),NFFT);
    DataFFT(1:NFFT/2,i1) = 2/NFFT*abs(DataFFT(1:NFFT/2,i1));%%单边谱
    DataFFT(1:NFFT/2,i1) = 20*log10(DataFFT(1:NFFT/2,i1));%%幅度转换
    DataFre(:,i1) = fs/NFFT*(0:NFFT/2-1);
end
SignalFre=fc;%JJI
% NoiseFre=28000;%噪声频段
signal_ind=round(SignalFre/(fs/NFFT)+1);
noise_ind1=signal_ind+3;
noise_ind2=signal_ind-3;
% Noise_ind=round(NoiseFre/(fs/NFFT)+1);
SNR=DataFFT(signal_ind,:)-(DataFFT(noise_ind1,:)+DataFFT(noise_ind2,:))/2;

end