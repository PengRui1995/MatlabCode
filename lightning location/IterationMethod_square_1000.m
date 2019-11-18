%% 功能：利用高斯牛顿迭代法，球面定位,将全球1度为精度划分网格，以每个格点为目标站的位置各定位1000次，求出1000次定位误差的均方根，结果数据保存在“.mat”文件中
% clear all;
% close all;
% clc;
%BS 探测站的位置
BSN=5;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS 发射源的位置
%BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';%old four stations
%BS=[30.54,32.79,32.79,28.29,28.29;114.37,111.76,116.98,116.98,111.76]';%500km square  with centra at wuhan
BS=[30.54,35.04,35.04,26.04,26.04;114.37,109.09,119.59,119.59,109.09]';%1000km square  with centra at wuhan
%MS =[32.04,130.81];%JJI
%MS =[-21.82,114.17];%NWC
%MS =[31,90,117.90];
%MS =[15.9,175.2];
%mode 'e':earth,'h': ellipsoidal model
mode = 'e';
%将全球按经纬度1度精度划分网格，
B=-90:1:90;
L=-180:1:180;
K=length(B);
M=length(L);
ntime =10;%每个点定位次数
MS_pos=zeros(K,M,2);
Res_pos=zeros(K,M,ntime,2);%每个格点的定位结果
Res_err=zeros(K,M,ntime);%每个格点定位结果的误差
Res_meanPos=zeros(K,M,2);%每个格点定位结果的平均位置
Res_rms =zeros(K,M);%每个格点定位结果的均方根误差
for k=1:K
    for m =1:M
        MS=[B(k),L(m)];%目标站点
        MS_pos(k,m,1)=MS(1);
        MS_pos(k,m,2)=MS(2);
        % mode ='e';
        % BS1为参考站，求时延矩阵 
        c=29979.2458; %光速，km
        % D,R 距离、时间差矩阵
        D=zeros(length(BS)-1,1);
        for index = 1:length(D)
            D(index)= fnGetDistance(BS(index+1,:),MS,mode)-fnGetDistance(BS(1,:),MS,mode);
        end
        %NOISE 时延精度，1代表1us。
        for i = 1:ntime
            NOISE =0;
            %R 时差向量
            R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
            %Q 时差误差协方差矩阵，默认设置为单位阵
            Q = diag(ones(BSN-1,1));
            %迭代初值点
            Pos_0=BS(1,:)+BS(2,:);
            Pos_0=Pos_0'./2;
            dis_err=100;
            count=0%最大迭代次数
            while dis_err>0.0001 &&  count<10000
                %J 偏导数矩阵
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