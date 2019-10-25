function [delay1,delay2,val,val2]=fnGetDelay(Far,Near,fs,fc)

    %% ��ƴ�ͨ�˲���,��ȡfc=22200HZ���ź�
    fs = 250000; % ������
    fc =22200;%����Ƶ��
    fcuts=[fc-500 fc-100 fc+100 fc+500];
    Ap=1;
    As=50;% ����ͨ�������˥��
    devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% ����ƫ����
    mags=[0 1 0];
    [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
    h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%     %% �˲�
     FarSta=Far;
    NearSta = Near;
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% 
    [c,lags]=xcorr(fdata(1:fs),ndata(1:fs),'coeff');
    [val,ind]=max(c);
    [val2,ind2]=min(c);
    figure
    plot(lags,c,'-o');
    delay1=lags(ind);
    delay2 =lags(ind2);

end