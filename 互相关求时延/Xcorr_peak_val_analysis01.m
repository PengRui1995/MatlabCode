%% 功能：分析一天中两站（Far/Nearsta）互相关结果与峰值的关系
clc
%%选择两站文件夹
%选择远站文件夹
far_dirpath = uigetdir('E:\VLF_Observed_Data','请选择远站文件夹');
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
   % disp(filepath);%显示路径，注释掉不显示
end
%%选择近站文件夹
near_dirpath = uigetdir('E:\VLF_Observed_Data','请选择远站文件夹');
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
for i=1:len
    filename1=near_fileNames{ind_near(i)};
    filename2=far_fileNames{ind_far(i)};
  disp(filename1); disp(filename2);
end
%% 求时延
if(1)
delay=zeros(2,len)';
peak_val =zeros(2,len)';
fs = 250000; % 采样率
fc =22200;%中心频率
for i=1:len
%%提取时刻的数据文件
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{ind_far(i)});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{ind_near(i)});
    %time 时长
    time =1;
    FarSta=far_ew(1:fs*time);
    NearSta=near_ew(1:fs*time);
    %% 分别求出两组信号的波形

    %% 设计带通滤波器,提取fc=22200HZ的信号

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
    %% 互相关求时延
    [c,lags]=xcorr(fdata,ndata,'coeff');
    [val_max,ind_max] = max(c);
    [val_min,ind_min] = min(c);
    delay(i,1)=lags(ind_max);
    delay(i,2)=lags(ind_min);
    peak_val(i,1)=val_max;
    peak_val(i,2)=val_min;
end
%%依次其时延并保存相关峰的值
%%作图分析
figure;
hold on
plot(peak_val(:,1),'-o');
plot(-peak_val(:,2),'-o');
legend('MAX_Peak_VAL','MIN_Peak_VAl');
figure
hold on
plot(delay(:,1),'-o');
plot(delay(:,2),'-o');
legend('MAX_Delay','MIN_Delay');
end