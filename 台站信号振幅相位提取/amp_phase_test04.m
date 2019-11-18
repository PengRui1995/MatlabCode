%% amp_phase_test04
clear all
clc
close all
%% 选择一个文件夹
dirpath = uigetdir('Z:\VLF_Observed_Data','请选择一天的数据');
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

%% sort fileNames in time order
for i=1:fileNum
strcell=strsplit(fileNames{i},',');
% strcell{4} is the index number of datafile,change it to int 
ind_str= strcell{4};
ind_int=str2num(ind_str);
ind_str=num2str(ind_int,'%04d');
strcell{4}=ind_str;
% for short
%strcell{4}=num2str(str2num(strcell{4}),'%04d');
%
fileNames{i}=[];
for j=1:length(strcell)
    fileNames{i}=[fileNames{i},',',strcell{j}];
end
end
fileNames=sort(fileNames);
for i=1:fileNum
strcell=strsplit(fileNames{i},',');
 ind_str =strcell{5};
 ind_int=str2num(ind_str);
 ind_str = num2str(ind_int);
 strcell{5}=ind_str;
 %for short
 %strcell{5}=num2str(str2num(strcell{5}));
 fileNames{i}=strcell{2};

 for j=3:length(strcell)
    fileNames{i}=[fileNames{i},',',strcell{j}];
end
end

amp=zeros(1,fileNum);
phase1=zeros(1,fileNum);
phase2=zeros(1,fileNum);
 ii=1
for i=1:fileNum
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
    A = NSdata(1:fs*ii);
    [amp(i),phase1(i),phase2(i)]=vlfMSKDemodulation_cl2(fs,fc,fb,A);
end
%
figure;
hold on
plot(phase1,'-o');
plot(phase2,'-o');
ylim([-pi,pi]);
figure
plot(amp,'-o');
save('mat\suizhou,2019-1-10,NS,NWC.mat');