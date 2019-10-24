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
%% 提取同通道台站的NS数据。

for i=[1,12]
%disp(timestamp(i));
  %% 提取同时刻两台站的NS通道数据
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{ind_far(i)});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{ind_near(i)});
    %%
    fs=250000;
    fc=22200;
   [delay(1,i),delay(2,i),c(1,i),c(2,i)]=fnGetDelay(far_ew(1:fs),near_ew(1+fs*1:fs*2),fs,fc);
  % [delay(1,i),delay(2,i),c(1,i),c(2,i)]=fnGetDelay(far_ew(1:fs),near_ew(1:fs*1),fs,fc);
end
figure
hold on
plot(delay(1,:),'-ro');
plot(delay(2,:),'-go');
legend('delay1','delay2');
figure
hold on
plot(c(1,:),'-r*');
plot(c(2,:),'-g*');
legend('谷值','峰值');

