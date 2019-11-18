%% ���ö༶����,�������������
clear all;
close all;
clc;

%BS ̽��վ��λ��
BSN=4;
%BS = [1,2,3,4,5,6,7,8,9,10;1,2,3,4,5,6,7,8,9,10]';
%BS=ones(4,2);
%MS ����Դ��λ��
BS=[29.0,52.98,31.57,30.54;103.0,122.5,113.32,114.37]';
MS =[32.04,130.81];
%MS =[-21.82,114.17];
% BS1Ϊ�ο�վ����ʱ�Ӿ���
c=29979.2458; %���٣�km
% D,R ���롢ʱ������
D=zeros(length(BS)-1,1);
for index = 1:length(D)
    D(index)= fnGetDistance(BS(index+1,:),MS,'e')-fnGetDistance(BS(1,:),MS,'e');
end
dis_err = ones(10,11);
%NOISE ʱ�Ӿ��ȣ�1����1us��
for  index_NOISE=1:51%��ͬ����
    NOISE =1*(index_NOISE-1);
    for index_time=1:1000%������λ10��
        R=D/c+1e-6*NOISE*(2*rand(size(D))-1);
        %k,m 
        dis_err1=20000;
        dis_err2=20000;
        dis_err3=20000;
        %һ�����񣬲���1�ȵľ���
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
                CostM1(i,j)= fnCost(BS,BSN,Pos,R,'e');
            end
        end
        [row,col]=find(CostM1==min(min(CostM1)));
        PosM1 = [B(row),L(col)];
        dis_err1=fnGetDistance(PosM1,MS,'e');
        %�����������0.1�ľ���

        if(1||dis_err1<200)
            Bmin2=PosM1(1)-3;
            Bmax2=PosM1(1)+3;
            Lmin2=PosM1(2)-3;
            Lmax2=PosM1(2)+3;
            B = Bmin2:0.1:Bmax2;
            L = Lmin2:0.1:Lmax2;
            CostM2 = zeros(length(B),length(L));
            for i=1:length(B)
                for j = 1:length(L)
                    Pos =[B(i),L(j)];
                    CostM2(i,j)= fnCost(BS,BSN,Pos,R,'e');
                end
            end
            [row,col]=find(CostM2==min(min(CostM2)));
            PosM2 = [B(row),L(col)];
            dis_err2=fnGetDistance(PosM2,MS,'e');
        end
        %�����������0.01�ľ���
        if(1||dis_err2<50)
            Bmin3=PosM2(1)-0.1*5;
            Bmax3=PosM2(1)+0.1*5;
            Lmin3=PosM2(2)-0.1*5;
            Lmax3=PosM2(2)+0.1*5;
            B = Bmin3:0.01:Bmax3;
            L = Lmin3:0.01:Lmax3;
            CostM3 = zeros(length(B),length(L));
            for i=1:length(B)
                for j = 1:length(L)
                    Pos =[B(i),L(j)];
                    CostM3(i,j)= fnCost(BS,BSN,Pos,R,'e');
                end
            end
            [row,col]=find(CostM3==min(min(CostM3)));
            PosM3 = [B(row),L(col)];
            dis_err3=fnGetDistance(PosM3,MS,'e');
        end
        dis_err(index_time,index_NOISE)=dis_err3;
    end
end
save('gridMethod05.mat');