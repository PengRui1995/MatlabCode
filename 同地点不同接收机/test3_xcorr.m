%批量处理台站信号时延
%比如选择远站为乐山，近站为武汉
%选取同个时间段乐山、武汉站的数据文件分别放在“leshan”、“wuhan”文件夹，
clear all;close all ;clc;
%%选择两站文件夹
%选择远站文件夹
far_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','请选择远站文件夹');
    if isequal(far_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',far_dirpath]);
    end
fileFolder=fullfile(far_dirpath);
%  将文件名存入元胞
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
far_fileNames={dirOutPut.name};%元胞，元素为各文件的绝对路径(包含文件名)，并已按字典顺序排序。
fileNum=length(far_fileNames);
for i=1:fileNum
    filename=far_fileNames{i};
    filepath=[fileFolder,'\',filename];
    %showaddAp(filepath,filename);%附加相位图
    %showwidespec(filepath,filename);
    %disp(filename);
    disp(filepath);%显示路径，注释掉不显示
end
%%选择近站文件夹
near_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','请选择远站文件夹');
    if isequal(near_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',near_dirpath]);
    end
fileFolder=fullfile(near_dirpath);
%将文件名存入元胞
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
near_fileNames={dirOutPut.name};%元胞，元素为各文件的绝对路径()，并已按字典顺序排序。
fileNum=length(near_fileNames);
%% 保存远近站数据对应时刻表
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
    %% 找到两站所有同时刻的文件
    %timestamp记录时刻，ind_far,in_near,对应在该时刻的数据在far/near_fileNames中的引索.
    [timestamp,ind_far,ind_near]=intersect(far_timestamp,near_timestamp);
    len=length(timestamp);
for i=1:fileNum
    filename=near_fileNames{i};
    filepath=[fileFolder,'\',filename];
    %showaddAp(filepath,filename);%附加相位图
    %showwidespec(filepath,filename);
    %disp(filename);
    disp(filepath);%显示路径，注释掉不显示
end
%%

delay_ew=zeros(1,fileNum);
delay_ns=zeros(1,fileNum);
delayArray=zeros(2,fileNum);
for ind_pass=1:2
    for i=1:fileNum
    %% 提取同时刻两台站的NS通道数据
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{i});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{i});
    if ind_pass==1
        FarSta=far_ns(1:2500000);
        NearSta=near_ns(1:2500000);
        elseif ind_pass==2
        FarSta=far_ew(1:2500000);
        NearSta=near_ew(1:2500000);  
    end
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
    %% 滤波
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% 两组信号做互相关
    [r_ff,lags_ff]=xcorr(ndata,'coeff');
    
    [r_fn,lags_fn]=xcorr(fdata,ndata,'coeff');%'coeff'归一化选项
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
title('20170501\_08:00:00-10:00:00\_EWNS通道求时延对比图');
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
