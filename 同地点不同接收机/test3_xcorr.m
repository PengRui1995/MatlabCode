%��������̨վ�ź�ʱ��
%����ѡ��ԶվΪ��ɽ����վΪ�人
%ѡȡͬ��ʱ�����ɽ���人վ�������ļ��ֱ���ڡ�leshan������wuhan���ļ��У�
clear all;close all ;clc;
%%ѡ����վ�ļ���
%ѡ��Զվ�ļ���
far_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','��ѡ��Զվ�ļ���');
    if isequal(far_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',far_dirpath]);
    end
fileFolder=fullfile(far_dirpath);
%  ���ļ�������Ԫ��
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
far_fileNames={dirOutPut.name};%Ԫ����Ԫ��Ϊ���ļ��ľ���·��(�����ļ���)�����Ѱ��ֵ�˳������
fileNum=length(far_fileNames);
for i=1:fileNum
    filename=far_fileNames{i};
    filepath=[fileFolder,'\',filename];
    %showaddAp(filepath,filename);%������λͼ
    %showwidespec(filepath,filename);
    %disp(filename);
    disp(filepath);%��ʾ·����ע�͵�����ʾ
end
%%ѡ���վ�ļ���
near_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','��ѡ��Զվ�ļ���');
    if isequal(near_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',near_dirpath]);
    end
fileFolder=fullfile(near_dirpath);
%���ļ�������Ԫ��
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
near_fileNames={dirOutPut.name};%Ԫ����Ԫ��Ϊ���ļ��ľ���·��()�����Ѱ��ֵ�˳������
fileNum=length(near_fileNames);
%% ����Զ��վ���ݶ�Ӧʱ�̱�
    far_filenum=length(far_fileNames);
    far_timestamp=cell(1,far_filenum);
    for i=1:far_filenum
        tempstr=far_fileNames{i};
        tempstr=strsplit(tempstr,',');
        tempstr=tempstr(7);
        far_timestamp{i}=tempstr{1};
    end
	near_filenum=length(near_fileNames);
    near_timestamp=cell(1,near_filenum);
    for i=1:near_filenum
        tempstr=near_fileNames{i};
        tempstr=strsplit(tempstr,',');
        tempstr=tempstr(7);
        near_timestamp{i}=tempstr{1};
    end
    %% �ҵ���վ����ͬʱ�̵��ļ�
    %timestamp��¼ʱ�̣�ind_far,in_near,��Ӧ�ڸ�ʱ�̵�������far/near_fileNames�е�����.
    [timestamp,ind_far,ind_near]=intersect(far_timestamp,near_timestamp);
    len=length(timestamp);
for i=1:fileNum
    filename=near_fileNames{i};
    filepath=[fileFolder,'\',filename];
    %showaddAp(filepath,filename);%������λͼ
    %showwidespec(filepath,filename);
    %disp(filename);
    disp(filepath);%��ʾ·����ע�͵�����ʾ
end
%%

delay_ew=zeros(1,fileNum);
delay_ns=zeros(1,fileNum);
delayArray=zeros(2,fileNum);
for ind_pass=1:2
    for i=1:fileNum
    %% ��ȡͬʱ����̨վ��NSͨ������
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{i});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{i});
    if ind_pass==1
        FarSta=far_ns(1:2500000);
        NearSta=near_ns(1:2500000);
        elseif ind_pass==2
        FarSta=far_ew(1:2500000);
        NearSta=near_ew(1:2500000);  
    end
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
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% �����ź��������
    [r_ff,lags_ff]=xcorr(ndata,'coeff');
    
    [r_fn,lags_fn]=xcorr(fdata,ndata,'coeff');%'coeff'��һ��ѡ��
    [r,lags]=xcorr(r_fn,r_ff,'coeff');
    [rsort,ind]=sort(r);
    %plot(lags,r,lags(ind(end)),rsort(end),'rs');
    delay=lags(ind(end));
    delayArray(ind_pass,i)=delay;
    disp(['delay=',num2str(delay)]);
    end
figure
plot(delayArray(ind_pass,:),'-o');
%axis([0,fileNum,500,100]);
end
delay_ns=delayArray(1,:);
delay_ew=delayArray(2,:);
figure 
hold on
plot(delay_ns,'-or');
plot(delay_ew,'-ob');
legend('ns','ew');
if(0)
title('20170501\_08:00:00-10:00:00\_EWNSͨ����ʱ�ӶԱ�ͼ');
% [val_min,ind_min]=min(delay_ns);
% [val_max,ind_max]=max(delay_ns);
% delay_ns(ind_min)=[];
% delay_ns(ind_max)=[];
% [val_min,ind_min]=min(delay_ew);
% [val_max,ind_max]=max(delay_ew);
% delay_ew(ind_min)=[];
% delay_ew(ind_max)=[];
%delay_ewns=(delay_ew+delay_ns)/2
%dlmwrite('txt\20170501_08_10_ewns.txt',delayArray');
end
