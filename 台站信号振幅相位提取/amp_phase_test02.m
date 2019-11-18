clear all
clc
close all
%% 选择一个文件夹
dirpath = uigetdir('D:\MATLAB\workspace','请选择一天的数据');
    if isequal(dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',dirpath]);
    end
fileFolder=fullfile(dirpath);
%% 
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
fileNames={dirOutPut.name};
fileNum=length(fileNames);

amp=zeros(1,fileNum);
phase1=zeros(1,fileNum);
phase2=zeros(1,fileNum);

for ii=1:1
for i=1:1:fileNum
    filename=fileNames{i};
    filepath=[fileFolder,'\',filename];
    disp(i);
    
    %showaddAp(filepath,filename);%附加相位图
    %showwidespec(filepath,filename);
    %disp(filename);
    fs=250000;
    fc=22200;
    fb=225;
    [EWdata,NSdata]=fnExtEWNSdata([fileFolder,'\'],filename);
    
    A = EWdata(1:fs*ii)-65535./2;
   
    [amp(i),phase1(i),phase2(i)]=vlfMSKDemodulation_cl2(fs,fc,fb,A);
    
    
end
% phase1(phase1==0)=[];
% phase2(phase2==0)=[];
phase_d_zp=phase1/pi*180;
phase_d_fp=phase2/pi*180;

amp(amp==0)=[];
subplot(2,1,1)
hold on
plot(phase_d_zp);
plot(phase_d_fp);
title(['N=',num2str(ii*fs),'(',num2str(ii),'s',')','  相位图']);
legend('正频点相位','负频点相位')
subplot(2,1,2) 
plot(amp);
title(['N=',num2str(ii*fs),'(',num2str(ii),'s',')','  振幅图']);
station='JJI';
date='2019-3-8';
% saveas(gca,['pic\',station,'\',date,'\',num2str(ii),'.fig']);
% close all
end