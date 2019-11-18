%% 功能：利用高斯牛顿迭代法，定位,球面
clear all;
close all;
clc;
%BS 探测站的位置
BSN=4;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS 发射源的位置
BS=[29.0,52.98,31.57,30.54;
    103.0,122.5,113.32,114.37]';
MS =[32.04,130.81];
MS =[-21.82,114.17];
% BS1为参考站，求时延矩阵
c=29979.2458; %光速，km
% D,R 距离、时间差矩阵
D=zeros(length(BS)-1,1);
for index = 1:length(D)
    D(index)= fnGetDistance(BS(index+1,:),MS,'e')-fnGetDistance(BS(1,:),MS,'e');
end
%NOISE 时延精度，1代表1us。
dis_er=ones(1,10000);
Pos_res=ones(10000,2);
for i = 1:10000
 
NOISE =1;
%R 时差向量
R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
%Q 时差误差协方差矩阵，默认设置为单位阵
Q = diag(ones(BSN-1,1));
%迭代初值点
Pos_0=BS(1,:)+BS(2,:);
Pos_0=Pos_0'./2;
dis_err=100;
while dis_err>0.0001
    %J 偏导数矩阵
    J_K=fnJ(BS,BSN,Pos_0,'e');
    F_K=fnFmethod(BS,BSN,Pos_0,'e');
    Pos_next = (J_K'/Q*J_K)\J_K'/Q*(R-F_K+J_K*Pos_0);
    dis_err = fnGetDistance(Pos_0,Pos_next,'e');
    Pos_0=Pos_next;
  
end
Pos_res(i,:)=Pos_0;

dis_er (i)=fnGetDistance(Pos_0,MS,'e');
end