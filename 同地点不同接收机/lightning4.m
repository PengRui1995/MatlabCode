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
%%
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
    FarSta=FarStaEW9s;
    NearSta = NearStaEW9s;
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% 
    [c,lags]=xcorr(fdata(1:fs),ndata(1:fs),'coeff');
    [val,ind]=max(c);
    [val2,ind2]=min(c);
    [val3,ind3]=max(abs(c));
    figure
    plot(lags,c,'-o');
    delay1=lags(ind)
    dalay2 =lags(ind2)
    dalay3 =lags(ind3)
    