function [phase_seq amp_seq]=fnExtPhaseAmpSeq(data,fc,fs)
%ExtPhaseAmpSeq=Extraction of Phase Amplitude Sequence��ȡ��λ�����
%���룺
%�����phase_seq��λ�У�amp_seq�����
%
%% ��ͨ�˲����������Ƶ��fc,����1000hz
fcuts=[fc-500,fc-100,fc+100,fc+500];    %����ͨ�������˥��
Ap=1;        
As=50;
mags=[0 1 0];%0->1 ��ʾ������ͨ ����֮����
%����ƫ����
devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];
%devs=����ָ������Ƶ������˲�����Ƶ����Ӧ����������ֵ֮�������������ƫ��
%ͨ���Ʋ���ָ���˲�����Ƶ����ͨ��������ֵ����С��ֵ֮��Ĳ�ֵ���������Ʋ�һ��С��1db������Ҳ��������ԣ�ͨ���Ʋ��ᵼ��ͨ���ڵķ�ֵ��С�б仯��һ��Ҫ��Խ�ߣ��Ʋ�ԽСԽ�á�ͨ���Ʋ����˲����Ľ����й�ϵ������Խ���Ʋ�ԽС��
%���˥������ͨ���У��в����ź�ͨ�������ź��裬����Ĳ��ֲ��ܲ���ȫ����ϣ�ֻ�в���˥��������������������С˥���������谭�����źŵ�������˥��Խ��������Խ�á�
[n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
data=filtfilt(hh,1,data);%����λ�˲���
%% �õ�I(t)��Q(t)�ź�
dataL=length(data);
fn=250000;%�ܲ�����
dt=1/fs;
tend=dataL/fs;
Msk_Date=data(1:fn*tend);
tn=(0:dataL-1)*dt;%����ʱ������
%********************************
Id=Msk_Date.*cos(2*pi*fc*tn);       %ͬ��֧·
Qd=Msk_Date.*cos(2*pi*fc*tn+pi/2);  %����֧·
%********************************
%%  FIR�˲��� ������ʱ�Ŀ�����˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcut_lp=[fc+2000 fc+4000];
Ap=1;
As=50;
devs=[10^(Ap/20-1)/10^(Ap/20+1),10^(-As/20)];
mags=[1 0];%��ͨ�˲�
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs);
lp_anti=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_anti=filtfilt(lp_anti,1,Id);
Qd_anti=filtfilt(lp_anti,1,Qd);
%% ������1��
down_sample_rate=1;
Id_data=Id_anti(1:down_sample_rate:end);
Qd_data=Qd_anti(1:down_sample_rate:end);
%% ��û����˲���,��ͨ�˲���
fcut=[300 450] ;
Ap=1;
As=50;
devs=[10^(Ap/20-1)/10^(As/20+1),10^(-As/20)];
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut,mags,devs,fs/down_sample_rate);
lp=fir1(n,Wn,kaiser(n+1,beta),'noscale');
%% ͨ���˲���
Id_after=filtfilt(lp,1,Id_data);
Qd_after=filtfilt(lp,1,Qd_data);
%% ����������
down_rate=1;
id=Id_after(1:down_rate:end);
qd=Qd_after(1:down_rate:end);
%% �����λ�����
%�����amplitude��
temp_amp=id.^2+qd.^2;
amp_seq=2*sqrt(temp_amp);
%amp_s = 20*log(5*amp_s/65535);
  %�������
base=id+1i*qd;
phase_seq=unwrap(angle(base));
%% �������Ƶ������λ

%fft���ٸ���Ҷ�任
%phase��λ
% base_fft=fftshift(fft(base));
% amp=mean(amp_s);
% phase=angle(base_fft(fs/down_sample_rate/down_rate/2-round(fb/2-1)))*180/pi;
%plot(phase,'-o');
% xlabel('Ƶ��/HZ');
% ylabel('�Ƕ�/o');
%figure;plot(20*log10(abs(base_fft)),'-o');
end