%% lightning01.m
%% 主要观察闪电信号
clear all ;close all ;clc;
%% 提取远站的EWNS通道数据
fs=250000;%采样率
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
FarStaEW=EWdata(1:fs*10);%远站EW通道10s数据
FarStaNS=NSdata(1:fs*10);%远站NS通道10s数据
%% 提取近站的EWNS通道数据
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
NearStaEW=EWdata(1:fs*10);%近站EW通道10s数据
NearStaNS=NSdata(1:fs*10);%近站NS通道10s数据
%% 比较同机器两通道的波形
bShowFar=1;
bShowNear=1;
%远站波形
if(bShowFar)
figure
subplot(2,1,1)
plot(FarStaEW,'-o');
title('FarStaEW');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
subplot(2,1,2)
plot(65535-FarStaNS,'-o');   
title('FarStaNS');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
figure
plot(FarStaEW,'-o');
hold on
plot(65535-FarStaNS,'-o');
legend('FarStaEW','FarStaNS');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
end
%近站波形
if(bShowNear)
figure
subplot(2,1,1)
plot(NearStaEW,'-o');
title('NearStaEW');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
subplot(2,1,2)
plot(NearStaNS,'-o');  
title('NearStaNS');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
figure
plot(NearStaEW,'-o');
hold on
plot(NearStaNS,'-o');
legend('NearStaEW','NearStaNS');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
end
%% 比较不同机器两通道的波形
% EW通道
bShowEW=1;
bShowNS=1;
if(bShowEW)
figure
subplot(2,1,1)
plot(FarStaEW,'-o');
title('FarStaEW');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
subplot(2,1,2)
plot(NearStaEW,'-o');
title('NearStaEW');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
figure
plot(FarStaEW,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
hold on
plot(NearStaEW,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
legend('FarStaEW','NearStaEW');  
end
% NS通道
if(bShowNS)
figure
subplot(2,1,1)
plot(FarStaNS,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
title('FarStaNS');
subplot(2,1,2)
plot(NearStaNS,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
title('NearStaNS');
figure
plot(FarStaNS,'-o');
hold on
plot(NearStaNS,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
legend('FarStaNS','NearStaNS');  
end
%% far前9秒，near后9秒
if(1)
figure
subplot(2,1,1)
FarStaEW9s=65535-FarStaEW(1:fs*9);
plot(FarStaEW9s,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
title('FarStaEW');
subplot(2,1,2)
NearStaEW9s=NearStaEW(1+fs*1:fs*10);
plot(NearStaEW9s,'-o');
xlabel('时间(采样点\4us)');
ylabel('电压数值');
title('NearStaEW');
figure
plot(FarStaEW9s,'-o');
hold on
plot(NearStaEW9s,'-o');
legend('FarStaEW','NearStaEW');  
xlabel('时间(采样点\4us)');
ylabel('电压数值');
end