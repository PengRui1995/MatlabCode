function wave=fnGetSFS(data,fs,fc)
% data ԭʼ���ݣ�����Ƶ�ʻ��
% fc  ��Ƶ�źŲ���
% fs  ������
  %% ��ƴ�ͨ�˲���,��ȡfc���ź�
%         fs = 250000; % ������
%         fc =22200;%����Ƶ��
        fcuts=[fc-500 fc-100 fc+100 fc+500];
        Ap=1;
        As=40;% ����ͨ�������˥��
        devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% ����ƫ����
        mags=[0 1 0];
        [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
        h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
        %% ����λ�˲�
        wave=filtfilt(h,1,data);    
end