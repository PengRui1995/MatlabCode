function BS_New=fnzoom(BS,center,time)
%BS     台站分布纬经度分布
%center 缩放中心
%time   放缩倍数
%BS_New 缩放后的台站分布
for i=1:length(BS)
    BS(i,:)=BS(i,:)-center;
end
BS=BS.*time;
for i=1:length(BS)
    BS(i,:)=BS(i,:)+center;
end
BS_New=BS;
end