function J= fnJ(BS,BSN,Pos,mode)
%% 计算偏导数矩阵
J = zeros(BSN-1,2);
%% delta 差分步长
delta = 1e-5;
%c 光速
c=29979.2458; %光速，km
for i =1:BSN-1
    %偏B
    J(i,1)=(fnGetDistance([Pos(1)+delta,Pos(2)],BS(i+1,:),mode)-fnGetDistance([Pos(1)+delta,Pos(2)],BS(1,:),mode))-(fnGetDistance([Pos(1)-delta,Pos(2)],BS(i+1,:),mode)-fnGetDistance([Pos(1)-delta,Pos(2)],BS(1,:),mode));
    J(i,1)=J(i,1)./(2*delta);
    %偏L
    J(i,2)=(fnGetDistance([Pos(1),Pos(2)+delta],BS(i+1,:),mode)-fnGetDistance([Pos(1),Pos(2)+delta],BS(1,:),mode))-(fnGetDistance([Pos(1),Pos(2)-delta],BS(i+1,:),mode)-fnGetDistance([Pos(1),Pos(2)-delta],BS(1,:),mode));
    J(i,2)=J(i,2)./(2*delta);
end
J = J./c;
end