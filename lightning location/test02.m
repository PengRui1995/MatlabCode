clear all;
close all;
clc;

%BS ̽��վ��λ��
BSN=4;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS ����Դ��λ��
BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';
MS =[40,100];
% BS1Ϊ�ο�վ����ʱ�Ӿ���
c=29979.2458; %���٣�km
% D,R ���롢ʱ������
D=zeros(length(BS)-1,1);
for index = 1:length(D)
    D(index)= fnGetDistance(BS(index+1,:),MS,'h')-fnGetDistance(BS(1,:),MS,'h');
end
%NOISE ʱ�Ӿ��ȣ�1����1us��
NOISE =0;
R=D/c+1e-6*NOISE*(2*rand(size(D))-1);

%k,m 
Bmin =30;
Bmax =50;
Lmin =80;
Lmax =110;
B = Bmin:0.05:Bmax;
L = Lmin:0.05:Lmax;
CostM=zeros(length(B),length(L));
for i=1:length(B)
    for j = 1:length(L)
        Pos =[B(i),L(j)];
        CostM(i,j)= fnCost(BS,BSN,Pos,R,'h');
    end
end
[row,col]=find(CostM==min(min(CostM)));
PosM = [B(row),L(col)];
dis_err=fnGetDistance(PosM,MS,'h');