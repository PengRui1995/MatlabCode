%% EW/NSͨ�������߶���EW����ģ�Ŀ���Ƿ���ͬ�ص�Ĳ�ͬ���߽��յ����ź��кͲ�ͬ��
clear all 
close all
clc
%��ȡ�ź�
FilterSpec ={ '*.cos','COS�ļ�(*.cos)';'*.*','�����ļ�'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'C:/Users/Administrator/Desktop/vlfdata/wuhan20191027/VLF_data');%�ļ���������׺
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
fs=250000;
FarStaEW=EWdata(1:fs*10);%ԶվEWͨ��10s����
FarStaNS=NSdata(1:fs*10);%ԶվNSͨ��10s����

%%
%%
figure 
hold on
plot(FarStaEW, '-o')
plot(FarStaNS, '-o');
legend('-old','-new');

%% 
fc=22200;
[P1,A1]=fnExtPhaseAmpSeq(FarStaEW-65535/2,fc,fs);
[P2,A2]=fnExtPhaseAmpSeq(FarStaNS-65535/2,fc,fs);
figure
hold on
plot(A1,'-o');
plot(A2,'-o');