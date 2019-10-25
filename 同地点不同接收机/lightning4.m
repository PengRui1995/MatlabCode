clear all ;close all ;clc;
%% ��ȡԶվ��EWNSͨ������
fs=250000;%������
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
FarStaEW=EWdata(1:fs*10);%ԶվEWͨ��10s����
FarStaNS=NSdata(1:fs*10);%ԶվNSͨ��10s����
%% ��ȡ��վ��EWNSͨ������
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
NearStaEW=EWdata(1:fs*10);%��վEWͨ��10s����
NearStaNS=NSdata(1:fs*10);%��վNSͨ��10s����
%% farǰ9�룬near��9��
if(1)
figure
subplot(2,1,1)
FarStaEW9s=65535-FarStaEW(1:fs*9);
plot(FarStaEW9s,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
title('FarStaEW');
subplot(2,1,2)
NearStaEW9s=NearStaEW(1+fs*1:fs*10);
plot(NearStaEW9s,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
title('NearStaEW');
figure
plot(FarStaEW9s,'-o');
hold on
plot(NearStaEW9s,'-o');
legend('FarStaEW','NearStaEW');  
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
end
%%
  %% �ֱ���������źŵĲ���
    fc=22200;%JJI
    fs=250000;%����Ƶ��
    %% ��ƴ�ͨ�˲���,��ȡfc=22200HZ���ź�
    fs = 250000; % ������
    fc =22200;%����Ƶ��
    fcuts=[fc-500 fc-100 fc+100 fc+500];
    Ap=1;
    As=50;% ����ͨ�������˥��
    devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% ����ƫ����
    mags=[0 1 0];
    [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
    h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    %% �˲�
    FarSta=FarStaEW9s;
    NearSta = NearStaEW9s;
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% 
    [c,lags]=xcorr(fdata(1:fs),ndata(1:fs),'coeff');
    [val,ind]=max(c);
    [val2,ind2]=min(c);
    [val3,ind3]=max(abs(c));
    figure
    plot(lags,c,'-o');
    delay1=lags(ind)
    dalay2 =lags(ind2)
    dalay3 =lags(ind3)
    