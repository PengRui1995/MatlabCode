%%% 能够批量处理并导出到txt文件,只能求出时延
clear all
close all
clc
disp('程序正在运行中，请稍等...');
%% 选择远站文件
%far_filepath=uigetdir('选择数据所在文件夹');
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
    %% 选择近站文件
    %far_filepath=uigetdir('选择数据所在文件夹');
    near_filepath='C:\Users\P.R\Desktop\VLF_Observed_Data';
    near_station='wuhan';
    day='20170501';
    near_fileFolder=fullfile(near_filepath,near_station,day);
    dirOutPut=dir(fullfile(near_fileFolder,'*.cos'));
    near_fileNames={dirOutPut.name};
    %disp(near_fileNames);
    near_filenum=length(near_fileNames);
    %% 保存远近站数据对应时刻表
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
    %% 找到两站所有同时刻的文件
    %timestamp记录时刻，ind_far,in_near,对应在该时刻的数据在far/near_fileNames中的引索.
    [timestamp,ind_far,ind_near]=intersect(far_timestamp,near_timestamp);
    len=length(timestamp);
    delayArray=zeros(2,len);%用来保存时延。
    %% 计算对应时刻的两站时延
    for i=1:len
        [far_ew,far_ns]=fnExtEWNSdata([far_fileFolder,'\'],far_fileNames{ind_far(i)});
        [near_ew,near_ns]=fnExtEWNSdata([near_fileFolder,'\'],near_fileNames{ind_near(i)});
        FarSta=far_ns(1:2500000);
        NearSta=near_ns(1:2500000);
        %% 分别求出两组信号的波形
        fc=22200;%JJI
        fs=250000;%采样频率
        %% 设计带通滤波器,提取fc=22200HZ的信号
        fs = 250000; % 采样率
        fc =22200;%中心频率
        fcuts=[fc-500 fc-100 fc+100 fc+500];
        Ap=1;
        As=50;% 定义通带及阻带衰减
        devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% 计算偏移量
        mags=[0 1 0];
        [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
        h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
        %% 零相位滤波
        fdata=filtfilt(h,1,FarSta);
        ndata=filtfilt(h,1,NearSta);
        %% 两组信号做互相关
        [r,lags]=xcorr(fdata,ndata,'coeff');%'coeff'归一化选项
        [rsort,ind]=sort(r);
        %plot(lags,r,lags(ind(end)),rsort(end),'rs');
        delay=lags(ind(end));
        delayArray(1,i)=delay;
        %%
        [r,lags]=xcorr(fdata(1*fs+1:8*fs),ndata(1*fs+1:8*fs),'coeff');%'coeff'归一化选项
        [rsort,ind]=sort(r);
        %plot(lags,r,lags(ind(end)),rsort(end),'rs');
        delay=lags(ind(end));
        delayArray(2,i)=delay;
        %disp(['delay=',num2str(delay)]);
    end
    %% 时延结果导出
    %选择保存路径
    %savepath=uigetdir('请选择一个保存路径');
    savepath='C:\Users\P.R\Desktop';
    %判断下面是否有xcorr_result文件夹，若没有则创建。
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
disp('程序运行结束');
% subject = '程序结果已出';
% content = '程序已经跑完了，你可以到实验室看看了！';
% mailTome(subject,content); %调用函数发邮件