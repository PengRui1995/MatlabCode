%% EW/NS通道的天线都是EW方向的，目的是分析同地点的不同天线接收到的信号有和不同，
clear all 
close all
clc
%提取信号
FilterSpec ={ '*.cos','COS文件(*.cos)';'*.*','所有文件'};
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,'C:/Users/Administrator/Desktop/vlfdata/wuhan20191027/VLF_data');%文件名包含后缀
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
fs=250000;
FarStaEW=EWdata(1:fs*10);%远站EW通道10s数据
FarStaNS=NSdata(1:fs*10);%远站NS通道10s数据

%%
%%
figure 
hold on
plot(FarStaEW, '-o')
plot(FarStaNS, '-o');
legend('-old','-new');

%% 
fc=22200;
[P1,A1]=fnExtPhaseAmpSeq(FarStaEW-65535/2,fc,fs);
[P2,A2]=fnExtPhaseAmpSeq(FarStaNS-65535/2,fc,fs);
figure
hold on
plot(A1,'-o');
plot(A2,'-o');