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
for ii=0.001:0.005:1
amp=zeros(1,fileNum);
phase1=zeros(1,fileNum);
phase2=zeros(1,fileNum);

for i=1:2
    filename=fileNames{i};
    filepath=[fileFolder,'\',filename];
    disp(i);
    
    %showaddAp(filepath,filename);%附加相位图
    %showwidespec(filepath,filename);
    %disp(filename);
    fs=250000;
    fc=19800;
    fb=200;
    [EWdata,NSdata]=fnExtEWNSdata([fileFolder,'\'],filename);
    
    A = EWdata(1:fs*ii);
   
    [amp(i),phase1(i),phase2(i)]=vlfMSKDemodulation_cl1(fs,fc,fb,A);
    
    
end

phase_d_zp=unwrap(phase1);
phase_d_fp=unwrap(phase2);

subplot(2,1,1)
hold on
plot(phase_d_zp);
plot(phase_d_fp);
title(['N=',num2str(ii*fs),'  相位图']);
subplot(2,1,2) 
plot(amp);
title(['N=',num2str(ii*fs),'  振幅图']);
saveas(gcf,['pic/',num2str(ii),'.fig'])
end
