%% ���ܣ����ø�˹ţ�ٵ����������涨λ,��ȫ��1��Ϊ���Ȼ���������ÿ�����ΪĿ��վ��λ�ø���λ1000�Σ����1000�ζ�λ���ľ�������������ݱ����ڡ�.mat���ļ���
% clear all;
% close all;
% clc;
%BS ̽��վ��λ��
BSN=5;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS ����Դ��λ��
%BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';%old four stations
%BS=[30.54,32.79,32.79,28.29,28.29;114.37,111.76,116.98,116.98,111.76]';%500km square  with centra at wuhan
BS=[30.54,35.04,35.04,26.04,26.04;114.37,109.09,119.59,119.59,109.09]';%1000km square  with centra at wuhan
%MS =[32.04,130.81];%JJI
%MS =[-21.82,114.17];%NWC
%MS =[31,90,117.90];
%MS =[15.9,175.2];
%mode 'e':earth,'h': ellipsoidal model
mode = 'e';
%��ȫ�򰴾�γ��1�Ⱦ��Ȼ�������
B=-90:1:90;
L=-180:1:180;
K=length(B);
M=length(L);
ntime =10;%ÿ���㶨λ����
MS_pos=zeros(K,M,2);
Res_pos=zeros(K,M,ntime,2);%ÿ�����Ķ�λ���
Res_err=zeros(K,M,ntime);%ÿ����㶨λ��������
Res_meanPos=zeros(K,M,2);%ÿ����㶨λ�����ƽ��λ��
Res_rms =zeros(K,M);%ÿ����㶨λ����ľ��������
for k=1:K
    for m =1:M
        MS=[B(k),L(m)];%Ŀ��վ��
        MS_pos(k,m,1)=MS(1);
        MS_pos(k,m,2)=MS(2);
        % mode ='e';
        % BS1Ϊ�ο�վ����ʱ�Ӿ��� 
        c=29979.2458; %���٣�km
        % D,R ���롢ʱ������
        D=zeros(length(BS)-1,1);
        for index = 1:length(D)
            D(index)= fnGetDistance(BS(index+1,:),MS,mode)-fnGetDistance(BS(1,:),MS,mode);
        end
        %NOISE ʱ�Ӿ��ȣ�1����1us��
        for i = 1:ntime
            NOISE =0;
            %R ʱ������
            R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
            %Q ʱ�����Э�������Ĭ������Ϊ��λ��
            Q = diag(ones(BSN-1,1));
            %������ֵ��
            Pos_0=BS(1,:)+BS(2,:);
            Pos_0=Pos_0'./2;
            dis_err=100;
            count=0%����������
            while dis_err>0.0001 &&  count<10000
                %J ƫ��������
                J_K=fnJ(BS,BSN,Pos_0,mode');
                F_K=fnFmethod(BS,BSN,Pos_0,mode);
                Pos_next = (J_K'/Q*J_K)\J_K'/Q*(R-F_K+J_K*Pos_0);
                dis_err = fnGetDistance(Pos_0,Pos_next,mode);
                Pos_0=Pos_next;
                count =count+1;
            end
            Res_pos(k,m,i,1)=Pos_0(1);
            Res_pos(k,m,i,2)=Pos_0(2);
        end
    end
end

for k=1:K
    for m =1:M
        for i =1:ntime
            Res_err(k,m,i)=fnGetDistance(Res_pos(k,m,i,:),MS_pos(k,m,:),mode);
            Res_meanPos(k,m,1)=Res_meanPos(k,m,1)+Res_pos(k,m,i,1);
            Res_meanPos(k,m,2)=Res_meanPos(k,m,2)+Res_pos(k,m,i,2);
            Res_rms(k,m)=Res_rms(k,m)+Res_err(k,m,i)*Res_err(k,m,i);
        end
        Res_meanPos(k,m,1)=Res_meanPos(k,m,1)/ntime;
        Res_meanPos(k,m,2)=Res_meanPos(k,m,2)/ntime;
        Res_rms(k,m)=sqrt(Res_rms(k,m)/ntime);
    end
 end