function val =fnCost(BS,BSN,Pos,R,mode)
%fnCost BS,BSN,Pos,Rcription
%BS：探测站坐标
%BS:使用前BSN个站
%Pos:[Lat,lon]%待计算点的纬经度
%R:时延数据
% Syntax: val =fnCost(BS,BSN,Pos,R)
% Long description
if(nargin==4)
    mode='h';
end
%c 光速
c=29979.2458; %光速，km

%Q 测时误差协方差矩阵
Q=diag(ones(BSN-1,1));%假设各站测时误差服从同一分布且相互独立

%Rm 由Pos计算的到各站的时延矩阵
Rm=zeros(BSN-1,1);
for index = 1:BSN-1
    Rm(index)=fnGetDistance(BS(index+1,:),Pos,mode)-fnGetDistance(BS(1,:),Pos,mode);
end
Rm=Rm/c;
val=c*c*(Rm-R)'*Q*(Rm-R);
end