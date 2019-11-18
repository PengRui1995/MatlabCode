%% ���ܣ����ø�˹ţ�ٵ���������λ,����
clear all;
close all;
clc;
%BS ̽��վ��λ��
BSN=4;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS ����Դ��λ��
BS=[29.0,52.98,31.57,30.54;
    103.0,122.5,113.32,114.37]';
MS =[32.04,130.81];
MS =[-21.82,114.17];
% BS1Ϊ�ο�վ����ʱ�Ӿ���
c=29979.2458; %���٣�km
% D,R ���롢ʱ������
D=zeros(length(BS)-1,1);
for index = 1:length(D)
    D(index)= fnGetDistance(BS(index+1,:),MS,'e')-fnGetDistance(BS(1,:),MS,'e');
end
%NOISE ʱ�Ӿ��ȣ�1����1us��
dis_er=ones(1,10000);
Pos_res=ones(10000,2);
for i = 1:10000
 
NOISE =1;
%R ʱ������
R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
%Q ʱ�����Э�������Ĭ������Ϊ��λ��
Q = diag(ones(BSN-1,1));
%������ֵ��
Pos_0=BS(1,:)+BS(2,:);
Pos_0=Pos_0'./2;
dis_err=100;
while dis_err>0.0001
    %J ƫ��������
    J_K=fnJ(BS,BSN,Pos_0,'e');
    F_K=fnFmethod(BS,BSN,Pos_0,'e');
    Pos_next = (J_K'/Q*J_K)\J_K'/Q*(R-F_K+J_K*Pos_0);
    dis_err = fnGetDistance(Pos_0,Pos_next,'e');
    Pos_0=Pos_next;
  
end
Pos_res(i,:)=Pos_0;

dis_er (i)=fnGetDistance(Pos_0,MS,'e');
end