%% lightning01.m
%% ��Ҫ�۲������ź�
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
%% �Ƚ�ͬ������ͨ���Ĳ���
bShowFar=1;
bShowNear=1;
%Զվ����
if(bShowFar)
figure
subplot(2,1,1)
plot(FarStaEW,'-o');
title('FarStaEW');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
subplot(2,1,2)
plot(65535-FarStaNS,'-o');   
title('FarStaNS');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
figure
plot(FarStaEW,'-o');
hold on
plot(65535-FarStaNS,'-o');
legend('FarStaEW','FarStaNS');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
end
%��վ����
if(bShowNear)
figure
subplot(2,1,1)
plot(NearStaEW,'-o');
title('NearStaEW');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
subplot(2,1,2)
plot(NearStaNS,'-o');  
title('NearStaNS');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
figure
plot(NearStaEW,'-o');
hold on
plot(NearStaNS,'-o');
legend('NearStaEW','NearStaNS');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
end
%% �Ƚϲ�ͬ������ͨ���Ĳ���
% EWͨ��
bShowEW=1;
bShowNS=1;
if(bShowEW)
figure
subplot(2,1,1)
plot(FarStaEW,'-o');
title('FarStaEW');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
subplot(2,1,2)
plot(NearStaEW,'-o');
title('NearStaEW');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
figure
plot(FarStaEW,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
hold on
plot(NearStaEW,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
legend('FarStaEW','NearStaEW');  
end
% NSͨ��
if(bShowNS)
figure
subplot(2,1,1)
plot(FarStaNS,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
title('FarStaNS');
subplot(2,1,2)
plot(NearStaNS,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
title('NearStaNS');
figure
plot(FarStaNS,'-o');
hold on
plot(NearStaNS,'-o');
xlabel('ʱ��(������\4us)');
ylabel('��ѹ��ֵ');
legend('FarStaNS','NearStaNS');  
end
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