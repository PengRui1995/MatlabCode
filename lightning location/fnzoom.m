function BS_New=fnzoom(BS,center,time)
%BS     ̨վ�ֲ�γ���ȷֲ�
%center ��������
%time   ��������
%BS_New ���ź��̨վ�ֲ�
for i=1:length(BS)
    BS(i,:)=BS(i,:)-center;
end
BS=BS.*time;
for i=1:length(BS)
    BS(i,:)=BS(i,:)+center;
end
BS_New=BS;
end