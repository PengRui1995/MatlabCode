clc;
clear all;
close all;
t =0:0.01:1;
a1=0;
y1=sin(2*pi*t);
y2=t.^2+a1;
%y3=t.^2+a2;
figure 
hold on
for i=1:10
    [c1,lags1]=xcorr(y2+i,y1);
    plot(lags1,c1);
    plot(lags1,-c1);
end