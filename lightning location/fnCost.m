function val =fnCost(BS,BSN,Pos,R,mode)
%fnCost BS,BSN,Pos,Rcription
%BS��̽��վ����
%BS:ʹ��ǰBSN��վ
%Pos:[Lat,lon]%��������γ����
%R:ʱ������
% Syntax: val =fnCost(BS,BSN,Pos,R)
% Long description
if(nargin==4)
    mode='h';
end
%c ����
c=29979.2458; %���٣�km

%Q ��ʱ���Э�������
Q=diag(ones(BSN-1,1));%�����վ��ʱ������ͬһ�ֲ����໥����

%Rm ��Pos����ĵ���վ��ʱ�Ӿ���
Rm=zeros(BSN-1,1);
for index = 1:BSN-1
    Rm(index)=fnGetDistance(BS(index+1,:),Pos,mode)-fnGetDistance(BS(1,:),Pos,mode);
end
Rm=Rm/c;
val=c*c*(Rm-R)'*Q*(Rm-R);
end