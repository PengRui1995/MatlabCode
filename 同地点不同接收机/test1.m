% ���ܣ��Ƚ����鲻ͬ�źţ�����ȡʱ���
% Ŀ�ģ���ͬ�ص�������̨��ͬ���ջ��������ݣ�(���߷������Ƕ�theta��,ʱ������ֵӦ��Ϊ0,������ͬ�ص㣬�źŵ�˥�����
%       ,�ŵ����,��������Ӱ�죬GPS��ʱ��Ӧ����ͬ��
clear all ;
% close all;
clc;
%% �ֱ���ȡͬһʱ�����̨վ��NS�ź�
%Զվ�ź���ȡ
FilterSpec ={ '*.cos','COS�ļ�(*.cos)';'*.*','�����ļ�'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'��ѡ��һ��Զվ����','C:\Users\P.R\Desktop\vlfdata\20170501_080000');%�ļ���������׺
[file_id,message] = fopen([PathName,FileName],'rb');
disp(FileName);
if file_id < 0      %�򿪴���
   disp(message);
end
Rawdatas = fread(file_id,'uint16'); %�����ݴ洢��ʽ��ȡ
Rawdatas = Rawdatas';               %������ת��
fclose(file_id);    %16bits���ȣ������ݳ���  
%�жϵ�ͨ������˫ͨ��
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
  %  A = NSdata;%ѡȡһ��ͨ������A = EWdata
  %  B = EWdata;
end
delay=199;
FarStaEW=EWdata(1:200000);
FarStaNS=NSdata(1:200000);
FarStaEWD=EWdata(1+delay:200000+delay);
%��վ�ź���ȡ
FilterSpec ={ '*.cos','COS�ļ�(*.cos)';'*.*','�����ļ�'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'��ѡ��һ����վ����','C:\Users\P.R\Desktop\vlfdata\20170501_080000');%�ļ���������׺
[file_id,message] = fopen([PathName,FileName],'rb');
disp(FileName);
if file_id < 0      %�򿪴���
   disp(message);
end
Rawdatas = fread(file_id,'uint16'); %�����ݴ洢��ʽ��ȡ
Rawdatas = Rawdatas';               %������ת��
fclose(file_id);    %16bits���ȣ������ݳ���  
%�жϵ�ͨ������˫ͨ��
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
  %  A = NSdata;%ѡȡһ��ͨ������A = EWdata
  %  B = EWdata;
end
NearStaEW=EWdata(1:200000);
NearStaNS=NSdata(1:200000);
% %% ���˵������ź�
% 
% NearStaEW = NearStaEW-mean(NearStaEW);
% FarStaEW = FarStaEW-mean(FarStaEW);
% threshold1 =2236;
% threshold2 =2500;
% FarStaEW (abs(FarStaEW )>threshold1)=0;
% NearStaEW(abs(FarStaEW )>threshold1)=0;
% FarStaEW (abs(NearStaEW )>threshold2)=0;
% NearStaEW (abs(NearStaEW )>threshold2)=0;
%% FIR�˲���ȡխ��̨վ�ź�
%% ��ͨ�˲����������Ƶ��fc,����1000hz
fc =22200;
fs =250000;
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
FarDateEW=filtfilt(hh,1,FarStaEW);%����λ�˲���
FarDateNS=filtfilt(hh,1,FarStaNS);%����λ�˲���
FarDateEWD=filtfilt(hh,1,FarStaEWD);
NearDateEW=filtfilt(hh,1,NearStaEW);%����λ�˲���
NearDateNS=filtfilt(hh,1,NearStaNS);

%% ѡ�����������ģʽ
ModeChoices=[1,2,3];
%% 1.FarDate �Լ�ʱ�������
if(1)
[c,lags]=xcorr(FarDateEW,FarDateEWD);
[val,ind] = max(c);
delayFar = lags(ind);
disp("1.ʱ�ӽ����");
delay
delayFar
end

%% 2.NearDate �Լ�ʱ�������


%% 3.FarDate��NearData �����
[c,lags]=xcorr(NearDateEW,FarDateEW,'coeff');
[val,ind] = max(c);
[val,ind2]=min(c);
delayFN = lags(ind);

delayFN2 = lags(ind2);
disp("3.ʱ�ӽ����");
delayFN
delayFN2
figure
plot(lags,c,'*');
%% 4.
if(0)
figure
plot(FarStaEW,'-o');
title("FarStaEW");
figure
plot(FarStaNS,'-o');
title("FarStaNS");
figure
plot(NearStaEW,'-o');
title("NearStaEW");
figure
plot(NearStaNS,'-o');
title("NearStaNS");
end