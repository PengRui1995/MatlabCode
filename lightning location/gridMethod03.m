%% 利用多级网格
clear all;
close all;
clc;

%BS 探测站的位置
BSN=4;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS 发射源的位置
BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';
MS =[32.040,130.810];
MS =[-21.816,114.166];
% BS1为参考站，求时延矩阵
c=29979.2458; %光速，km
% D,R 距离、时间差矩阵
D=zeros(length(BS)-1,1);
for index = 1:length(D)
    D(index)= fnGetDistance(BS(index+1,:),MS,'h')-fnGetDistance(BS(1,:),MS,'h');
end
%NOISE 时延精度，1代表1us。
NOISE =0;
R=D/c+1e-6*NOISE*(2*rand(size(D))-1);

%k,m 
dis_err1=20000;
dis_err2=20000;
dis_err3=20000;
%一级网格，采用1度的精度
Bmin1=round(MS(1)-10);
Bmax1 =round(MS(1)+10);
Lmin1=round(MS(2)-10);
Lmax1=round(MS(2)+10);
B = Bmin1:1:Bmax1;
L = Lmin1:1:Lmax1;
CostM1=zeros(length(B),length(L));
for i=1:length(B)
    for j = 1:length(L)
        Pos =[B(i),L(j)];
        CostM1(i,j)= fnCost(BS,BSN,Pos,R,'h');
    end
end
[row,col]=find(CostM1==min(min(CostM1)));
PosM1 = [B(row),L(col)];
dis_err1=fnGetDistance(PosM1,MS,'h');
%二级网格采用0.1的精度

if(1||dis_err1<200)
Bmin2=PosM1(1)-1;
Bmax2=PosM1(1)+1;
Lmin2=PosM1(2)-1;
Lmax2=PosM1(2)+1;
B = Bmin2:0.1:Bmax2;
L = Lmin2:0.1:Lmax2;
CostM2 = zeros(length(B),length(L));
for i=1:length(B)
    for j = 1:length(L)
        Pos =[B(i),L(j)];
        CostM2(i,j)= fnCost(BS,BSN,Pos,R,'h');
    end
end
[row,col]=find(CostM2==min(min(CostM2)));
PosM2 = [B(row),L(col)];
dis_err2=fnGetDistance(PosM2,MS,'h');
end
%三级网格采用0.01的精度
if(1||dis_err2<20)
Bmin3=PosM2(1)-0.1;
Bmax3=PosM2(1)+0.1;
Lmin3=PosM2(2)-0.1;
Lmax3=PosM2(2)+0.1;
B = Bmin3:0.01:Bmax3;
L = Lmin3:0.01:Lmax3;
CostM3 = zeros(length(B),length(L));
for i=1:length(B)
    for j = 1:length(L)
        Pos =[B(i),L(j)];
        CostM3(i,j)= fnCost(BS,BSN,Pos,R,'h');
    end
end
[row,col]=find(CostM3==min(min(CostM2)));
PosM3 = [B(row),L(col)];
dis_err3=fnGetDistance(PosM3,MS,'h');
end