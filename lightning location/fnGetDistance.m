function dis = fnGetDistance(PosA,PosB,mode)
    if(nargin==2)
        mode='e';%默认使用标准球模型
    end
    if(mode=='e')
        Re=6371.393;%地球平均半径(km).
        %% 基于标准球面模型得到两点大地弧长
        lonA=PosA(2)/180*pi;%经度(度)
        lonB=PosB(2)/180*pi;
        latA=PosA(1)/180*pi;%纬度(度)
        latB=PosB(1)/180*pi;
  %  disp('你选择了模式1');  
    cosAOB=sin(latA)*sin(latB)+cos(latA)*cos(latB)*cos(lonB-lonA);
    dis = Re*acos(cosAOB);
    elseif(mode=='h')
        %% 基于标准椭球面模型得到两点大地弧长  
        lonA=PosA(2);%经度(度)
        lonB=PosB(2);
        latA=PosA(1);%纬度(度)
        latB=PosB(1);
        Ax = txsite('Name','接收站','Latitude',latA,'Longitude',lonA);%发射站
        Bx = rxsite('Name','发射站','Latitude',latB,'Longitude',lonB);%接收站
    dis = distance(Ax,Bx,'geodesic')/1000;
   % disp('你选择了模式2');
    else
        %%模式选择有误
        error('距离计算模式选择有误');
    end
end