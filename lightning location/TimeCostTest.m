%% 测试利用球面和椭球面计算10000次距离耗时。
clear all;
close all;
clc;
tic;
mode1='e';
mode2='h';
for i=1:10000
    PosA=zeros(2,1);
    PosA(1)=180*rand(1)-90;
    PosA(2)=360*rand(1)-180;
    PosB=zeros(2,1);
    PosB(1)=180*rand(1)-90;
    PosB(2)=360*rand(1)-180;
    dis1(i)=fnGetDistance(PosA,PosB,mode1);
end
t1=toc;
for i=1:10000
    PosA=zeros(2,1);
    PosA(1)=180*rand(1)-90;
    PosA(2)=360*rand(1)-180;
    PosB=zeros(2,1);
    PosB(1)=180*rand(1)-90;
    PosB(2)=360*rand(1)-180;
    dis2(i)=fnGetDistance(PosA,PosB,mode2);
end
t2=toc;
time1=t1/10000;
time2=(t2-t1)/10000;