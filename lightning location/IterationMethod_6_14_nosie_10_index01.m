%% 功能：利用高斯牛顿迭代法，球面定位,将1度为精度划分网格，以每个格点为目标站的位置各定位1000次，求出1000次定位误差的均方根，结果数据保存在“.mat”文件中
%构型：6-14
% clear all;
% close all;
% clc;
%BS 探测站的位置
BSN=6;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS 发射源的位置
%BS=[30.54,119.59;30.54,109.09;30.54,114.37];%3-01,直线型
%BS=[30.54,114.37;30.54,109.09;30.54,119.59];%3-02,直线型
%BS=[35.04,114.37;30.54,114.37;30.54,119.59];%3-06,‘L’形
%BS=[35.74,114.37;27.94,119.59;27.94,109.09];%3-07,正三角形
%BS=[35.04,109.09;35.04,119.59;26.04,119.59;26.04,109.09];%4-04,正方形
%BS=[35.04,119.59;35.04,109.09;26.04,119.59;26.04,109.09];%4-05,正方形
%BS=[26.04,119.59;35.04,109.09;35.04,119.59;26.04,109.09];%4-06,正方形
%BS=[30.54,119.59;35.04,109.09;30.54,109.09;30.54,114.37];%4-07,正方形
%BS=[30.54,114.37;35.04,109.09;30.54,109.09;30.54,119.59];%4-08,正方形
%BS=[30.54,109.09;35.04,109.09;30.54,114.37;30.54,119.59];%4-09,正方形
%BS=[35.04,109.09;30.54,109.09;30.54,114.37;30.54,119.59];%4-10,正方形;
%BS=[27.94,119.59;35.74,114.37;27.94,109.09;30.54,114.37];%4-12,星形;
%BS=[30.54,114.37;27.94,119.59;35.74,114.37;27.94,109.09];%4-11,星形;
%BS=[35.04,114.37;30.54,109.09;30.54,114.37;30.54,119.59];%4-13,'T'形
%BS=[30.54,109.09;35.04,114.37;30.54,114.37;30.54,119.59];%4-14,'T'形
%BS=[30.54,114.37;35.04,114.37;30.54,109.09;30.54,119.59];%4-15,'T'形
%BS=[26.04,109.09;35.04,109.09;35.04,119.59;26.04,119.59;30.54,111.73;30.54,116.98];%6-04,'4+2'型
BS=[34.43,116.96;34.43,111.81;30.54,119.54;26.65,116.96;26.65,111.81;30.54,109.25];%6-14,正6边形
%BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';%old four stations
%BS=[30.54,32.79,32.79,28.29,28.29;114.37,111.76,116.98,116.98,111.76]';%500km square  with centra at wuhan
%BS=[30.54,35.04,35.04,26.04,26.04;114.37,109.09,119.59,119.59,109.09]';%1000km square  with centra at wuhan
%BS(1,:)=[];
%MS =[32.04,130.81];%JJI
%MS =[-21.82,114.17];%NWC
%MS =[31,90,117.90];
%MS =[15.9,175.2];
%mode 'e':earth,'h': ellipsoidal model
mode = 'e';
%网格范围限制在[Bmin,Bmax],[Lmin,Lmax]中
% BMAX=round(BS(1,1))+20;
% BMIN=-BMAX;
% LMIN=round(BS(1,2))-20;
% LMAX=round(BS(1,2))+20;
BMAX=53;
BMIN=-42;
LMIN=73;
LMAX=153;

B=BMIN:2:BMAX;
L=LMIN:2:LMAX;
K=length(B);
M=length(L);
ntime =1000;%每个点定位次数
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
            NOISE =10;
            %R 时差向量
            R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
            %Q 时差误差协方差矩阵，默认设置为单位阵
            Q = diag(ones(BSN-1,1));
            %迭代初值点
            Pos_0=BS(1,:)+BS(2,:);
            Pos_0=Pos_0'./2;
            dis_err=100;
            count=0%迭代次数
            while dis_err>0.001 &&  count<10000
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
%% 保存数据
 NBS=4;%台站数量
 shape='方阵';%布站形状
 boundary=['B_',num2str(BMIN),'_',num2str(BMAX),',','L_',num2str(LMIN),'_',num2str(LMAX)];%定位仿真范围；
 %save(['result\mat\布站_4站_武汉中心1000公里方阵_,定位范围',boundary,',noise_',num2str(NOISE),'us,ntime_',num2str(ntime),'.mat']);
 filename=['布站_6_14,范围_',boundary,'_精度_2度_noise_10us_ntime_1000'];
 save(['result\mat\',filename,'.mat']);
 %save(['result\mat\布站_3_07,范围_',boundary,'_精度_2度_noise_10us_ntime_1000.mat']);
 %% 均方根误差分布图
 if(1)
 figure
[X,Y]=meshgrid(L,B);
surf(X,Y,Res_rms);
hold on
xlabel('经度(度)');
ylabel('纬度(度)');
view([0,90]);
colorbar
hco = colorbar ;
t = get(hco,'YTickLabel');
t = strcat(t,'km');
set(hco,'YTickLabel',t);
shading interp
plot3(BS(:,2),BS(:,1),10e9*ones(length(BS(:,1))),'k*');
hold on
plot3(BS(1,2),BS(1,1),10e9,'r*');
xlim([LMIN,LMAX]);
ylim([BMIN,BMAX]);
title([filename,' Rms'],'Interpreter','none');
savefig(['result\fig\',filename,'.fig']);
% figure
% [X,Y]=meshgrid(L,B);
% mesh(X,Y,Res_rms);
% hold on
% xlabel('经度(度)');
% ylabel('纬度(度)');
% view([0,90]);
% colorbar
% hco = colorbar ;
% t = get(hco,'YTickLabel');
% t = strcat(t,'km');
% set(hco,'YTickLabel',t);
% shading interp
% plot3(BS(:,2),BS(:,1),10*ones(length(BS(:,1))),'r*');
% xlim([LMIN,LMAX]);
% ylim([BMIN,BMAX]);
 end
