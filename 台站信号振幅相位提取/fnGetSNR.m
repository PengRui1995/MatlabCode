function SNR=fnGetSNR(Sdata,fs,fc)
% sdataָԴ����
% fs�����ʣ�fc����Ƶ��

%Sdata=Sdata(1:250000);
%% ��ͨ�˲������300Hz-50000kHZ
%fs = 250000; % ������
fcuts=[300 500 50000 51000];
Ap=1;
As=40;% ����ͨ�������˥��
devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% ����ƫ����
mags=[0 1 0];
[n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
h_LP=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
data=filtfilt(h_LP,1,Sdata);%����λ�˲���

DataL=length(data);
%% ����FFT�״���
NFFT =2048*1;  %FFT��������
h = hamming(NFFT);  %�Ӵ�������Ƶ��й©
h = h';
DataL=length(data);
SegNum = floor(DataL/NFFT);     %���������ݶ���
dt = 1/fs*NFFT;     %ÿ��ʱ����
DataFFT = zeros(NFFT,SegNum);
DataFre = zeros(NFFT/2,SegNum);
for i1 = 1:SegNum %���ݷֶζ���
    DataFFT(:,i1) = fft(h.*data(1+NFFT*(i1-1):NFFT*i1),NFFT);
    DataFFT(1:NFFT/2,i1) = 2/NFFT*abs(DataFFT(1:NFFT/2,i1));%%������
    DataFFT(1:NFFT/2,i1) = 20*log10(DataFFT(1:NFFT/2,i1));%%����ת��
    DataFre(:,i1) = fs/NFFT*(0:NFFT/2-1);
end
SignalFre=fc;%JJI
% NoiseFre=28000;%����Ƶ��
signal_ind=round(SignalFre/(fs/NFFT)+1);
noise_ind1=signal_ind+3;
noise_ind2=signal_ind-3;
% Noise_ind=round(NoiseFre/(fs/NFFT)+1);
SNR=DataFFT(signal_ind,:)-(DataFFT(noise_ind1,:)+DataFFT(noise_ind2,:))/2;

end