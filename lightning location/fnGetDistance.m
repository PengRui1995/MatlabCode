function dis = fnGetDistance(PosA,PosB,mode)
    if(nargin==2)
        mode='e';%Ĭ��ʹ�ñ�׼��ģ��
    end
    if(mode=='e')
        Re=6371.393;%����ƽ���뾶(km).
        %% ���ڱ�׼����ģ�͵õ������ػ���
        lonA=PosA(2)/180*pi;%����(��)
        lonB=PosB(2)/180*pi;
        latA=PosA(1)/180*pi;%γ��(��)
        latB=PosB(1)/180*pi;
  %  disp('��ѡ����ģʽ1');  
    cosAOB=sin(latA)*sin(latB)+cos(latA)*cos(latB)*cos(lonB-lonA);
    dis = Re*acos(cosAOB);
    elseif(mode=='h')
        %% ���ڱ�׼������ģ�͵õ������ػ���  
        lonA=PosA(2);%����(��)
        lonB=PosB(2);
        latA=PosA(1);%γ��(��)
        latB=PosB(1);
        Ax = txsite('Name','����վ','Latitude',latA,'Longitude',lonA);%����վ
        Bx = rxsite('Name','����վ','Latitude',latB,'Longitude',lonB);%����վ
    dis = distance(Ax,Bx,'geodesic')/1000;
   % disp('��ѡ����ģʽ2');
    else
        %%ģʽѡ������
        error('�������ģʽѡ������');
    end
end