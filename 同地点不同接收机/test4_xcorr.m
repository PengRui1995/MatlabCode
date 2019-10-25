%%% �ܹ���������������txt�ļ�,ֻ�����ʱ��
clear all
close all
clc
disp('�������������У����Ե�...');
%% ѡ��Զվ�ļ�
%far_filepath=uigetdir('ѡ�����������ļ���');
far_filepath='C:\Users\P.R\Desktop\VLF_Observed_Data';
for ind_station=1:1
    if ind_station==1
    far_station='leshan';
    elseif ind_station==2
    far_station='mohe';
    elseif ind_station==3
    far_station='suizhou';
    end
    far_station='leshan';
    day='20170501';
    far_fileFolder=fullfile(far_filepath,far_station,day);
    dirOutPut=dir(fullfile(far_fileFolder,'*.cos'));
    far_fileNames={dirOutPut.name};
    %disp(far_fileNames);
    far_filenum=length(far_fileNames);
    %% ѡ���վ�ļ�
    %far_filepath=uigetdir('ѡ�����������ļ���');
    near_filepath='C:\Users\P.R\Desktop\VLF_Observed_Data';
    near_station='wuhan';
    day='20170501';
    near_fileFolder=fullfile(near_filepath,near_station,day);
    dirOutPut=dir(fullfile(near_fileFolder,'*.cos'));
    near_fileNames={dirOutPut.name};
    %disp(near_fileNames);
    near_filenum=length(near_fileNames);
    %% ����Զ��վ���ݶ�Ӧʱ�̱�
    far_timestamp=cell(1,far_filenum);
    for i=1:far_filenum
        tempstr=far_fileNames{i};
        tempstr=strsplit(tempstr,',');
        tempstr=tempstr(7);
        far_timestamp{i}=tempstr{1};
    end
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
    delayArray=zeros(2,len);%��������ʱ�ӡ�
    %% �����Ӧʱ�̵���վʱ��
    for i=1:len
        [far_ew,far_ns]=fnExtEWNSdata([far_fileFolder,'\'],far_fileNames{ind_far(i)});
        [near_ew,near_ns]=fnExtEWNSdata([near_fileFolder,'\'],near_fileNames{ind_near(i)});
        FarSta=far_ns(1:2500000);
        NearSta=near_ns(1:2500000);
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
        %% ����λ�˲�
        fdata=filtfilt(h,1,FarSta);
        ndata=filtfilt(h,1,NearSta);
        %% �����ź��������
        [r,lags]=xcorr(fdata,ndata,'coeff');%'coeff'��һ��ѡ��
        [rsort,ind]=sort(r);
        %plot(lags,r,lags(ind(end)),rsort(end),'rs');
        delay=lags(ind(end));
        delayArray(1,i)=delay;
        %%
        [r,lags]=xcorr(fdata(1*fs+1:8*fs),ndata(1*fs+1:8*fs),'coeff');%'coeff'��һ��ѡ��
        [rsort,ind]=sort(r);
        %plot(lags,r,lags(ind(end)),rsort(end),'rs');
        delay=lags(ind(end));
        delayArray(2,i)=delay;
        %disp(['delay=',num2str(delay)]);
    end
    %% ʱ�ӽ������
    %ѡ�񱣴�·��
    %savepath=uigetdir('��ѡ��һ������·��');
    savepath='C:\Users\P.R\Desktop';
    %�ж������Ƿ���xcorr_result�ļ��У���û���򴴽���
%     if  exist(fullfile(savepath,'xcorr_result'),'dir')==0
%         mkdir(fullfile(savepath,'xcorr_result'));
%     end
    %suizhou-wuhan-xcorrdelay-2017-05-01
%     method='xcorrdelay';
%     savefilename=[far_station,'-',near_station,'-',method,'-',day,'.txt'];
%     fid=fopen(fullfile(savepath,'xcorr_result',savefilename),'w');
%     for i=1:len
%         fprintf(fid,'%s %d\n',timestamp{i},delayArray(i));
%     end
%     fclose(fid);
end
disp('�������н���');
% subject = '�������ѳ�';
% content = '�����Ѿ������ˣ�����Ե�ʵ���ҿ����ˣ�';
% mailTome(subject,content); %���ú������ʼ�