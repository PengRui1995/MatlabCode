% 功能：比较两组不同信号，并获取时间差
% 目的：在同地点利用两台不同接收机接收数据，(天线方向相差角度theta）,时延理论值应该为0,由于在同地点，信号的衰减情况
%       ,信道情况,环境因素影响，GPS授时都应该相同。
clear all ;
% close all;
clc;
%% 分别提取同一时间段两台站的NS信号
%远站信号提取
FilterSpec ={ '*.cos','COS文件(*.cos)';'*.*','所有文件'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'请选择一个远站数据','C:\Users\P.R\Desktop\vlfdata\20170501_080000');%文件名包含后缀
[file_id,message] = fopen([PathName,FileName],'rb');
disp(FileName);
if file_id < 0      %打开错误
   disp(message);
end
Rawdatas = fread(file_id,'uint16'); %按数据存储方式读取
Rawdatas = Rawdatas';               %对数据转置
fclose(file_id);    %16bits长度，即数据长度  
%判断单通道还是双通道
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
  %  A = NSdata;%选取一个通道，或A = EWdata
  %  B = EWdata;
end
delay=199;
FarStaEW=EWdata(1:200000);
FarStaNS=NSdata(1:200000);
FarStaEWD=EWdata(1+delay:200000+delay);
%近站信号提取
FilterSpec ={ '*.cos','COS文件(*.cos)';'*.*','所有文件'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'请选择一个近站数据','C:\Users\P.R\Desktop\vlfdata\20170501_080000');%文件名包含后缀
[file_id,message] = fopen([PathName,FileName],'rb');
disp(FileName);
if file_id < 0      %打开错误
   disp(message);
end
Rawdatas = fread(file_id,'uint16'); %按数据存储方式读取
Rawdatas = Rawdatas';               %对数据转置
fclose(file_id);    %16bits长度，即数据长度  
%判断单通道还是双通道
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
  %  A = NSdata;%选取一个通道，或A = EWdata
  %  B = EWdata;
end
NearStaEW=EWdata(1:200000);
NearStaNS=NSdata(1:200000);
% %% 过滤掉闪电信号
% 
% NearStaEW = NearStaEW-mean(NearStaEW);
% FarStaEW = FarStaEW-mean(FarStaEW);
% threshold1 =2236;
% threshold2 =2500;
% FarStaEW (abs(FarStaEW )>threshold1)=0;
% NearStaEW(abs(FarStaEW )>threshold1)=0;
% FarStaEW (abs(NearStaEW )>threshold2)=0;
% NearStaEW (abs(NearStaEW )>threshold2)=0;
%% FIR滤波提取窄带台站信号
%% 带通滤波器设计中心频率fc,带宽1000hz
fc =22200;
fs =250000;
fcuts=[fc-500,fc-100,fc+100,fc+500];    %定义通带和阻带衰减
Ap=1;        
As=50;
mags=[0 1 0];%0->1 表示带阻变带通 ，反之亦是
%计算偏移量
devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];
%devs=用于指定各个频带输出滤波器的频率响应与其期望幅值之间的最大输出误差或偏差
%通带纹波是指在滤波器的频响中通带的最大幅值和最小幅值之间的差值，正常的纹波一般小于1db。不过也视情况而言，通带纹波会导致通带内的幅值大小有变化，一般要求越高，纹波越小越好。通带纹波和滤波器的阶数有关系，阶数越大纹波越小。
%阻带衰减：在通带中，有部分信号通，部分信号阻，而阻的部分不能不能全部阻断，只有部分衰减，部分留了下来，最小衰减描述了阻碍受阻信号的能力，衰减越大，则能力越好。
[n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
FarDateEW=filtfilt(hh,1,FarStaEW);%零相位滤波器
FarDateNS=filtfilt(hh,1,FarStaNS);%零相位滤波器
FarDateEWD=filtfilt(hh,1,FarStaEWD);
NearDateEW=filtfilt(hh,1,NearStaEW);%零相位滤波器
NearDateNS=filtfilt(hh,1,NearStaNS);

%% 选择运行下面的模式
ModeChoices=[1,2,3];
%% 1.FarDate 自加时延求互相关
if(1)
[c,lags]=xcorr(FarDateEW,FarDateEWD);
[val,ind] = max(c);
delayFar = lags(ind);
disp("1.时延结果：");
delay
delayFar
end

%% 2.NearDate 自加时延求互相关


%% 3.FarDate和NearData 互相关
[c,lags]=xcorr(NearDateEW,FarDateEW,'coeff');
[val,ind] = max(c);
[val,ind2]=min(c);
delayFN = lags(ind);

delayFN2 = lags(ind2);
disp("3.时延结果：");
delayFN
delayFN2
figure
plot(lags,c,'*');
%% 4.
if(0)
figure
plot(FarStaEW,'-o');
title("FarStaEW");
figure
plot(FarStaNS,'-o');
title("FarStaNS");
figure
plot(NearStaEW,'-o');
title("NearStaEW");
figure
plot(NearStaNS,'-o');
title("NearStaNS");
end