 %����һ�����Ĳ��
 delta=0.01;
 t=0:0.01:10;
 y=sin(2*pi*t);
 y_diffl=2*pi*cos(2*pi*t);%΢��
 y_diffe=zeros(1,length(y));%���
 for i=1:length(y)
    y_diffe(i)=(sin(2*pi*(t(i)+delta))-sin(2*pi*(t(i)-delta)))/(2*delta);
 end
 hold on 
 plot(y);
 figure
 plot(y_diffl);
 figure
 plot(y_diffe);
 