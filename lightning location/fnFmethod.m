function  Rm =fnFmethod(BS,BSN,Pos,mode)
%���ܣ���λ��Pos����õ㵽��վ��ʱ�
%fnFmethod��BS,BSN,Pos,Rcription
%BS��̽��վ����
%BSN:ʹ��ǰBSN��վ
%Pos:[Lat,lon]%��������γ����
% Long description
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

end