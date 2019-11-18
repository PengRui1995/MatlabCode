%% ���ܣ�����һ������վ��Far/Nearsta������ؽ�����ֵ�Ĺ�ϵ
clc
%%ѡ����վ�ļ���
%ѡ��Զվ�ļ���
far_dirpath = uigetdir('E:\VLF_Observed_Data','��ѡ��Զվ�ļ���');
    if isequal(far_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',far_dirpath]);
    end
fileFolder=fullfile(far_dirpath);
%  ���ļ�������Ԫ��
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
far_fileNames={dirOutPut.name};%Ԫ����Ԫ��Ϊ���ļ��ľ���·��(�����ļ���)�����Ѱ��ֵ�˳������
fileNum=length(far_fileNames);
for i=1:fileNum
    filename=far_fileNames{i};
    filepath=[fileFolder,'\',filename];
    %showaddAp(filepath,filename);%������λͼ
    %showwidespec(filepath,filename);
    %disp(filename);
   % disp(filepath);%��ʾ·����ע�͵�����ʾ
end
%%ѡ���վ�ļ���
near_dirpath = uigetdir('E:\VLF_Observed_Data','��ѡ��Զվ�ļ���');
    if isequal(near_dirpath,0)
       disp('User selected Cancel');
    else
       disp(['User selected ',near_dirpath]);
    end
fileFolder=fullfile(near_dirpath);
%���ļ�������Ԫ��
dirOutPut=dir(fullfile(fileFolder,'*.cos'));
near_fileNames={dirOutPut.name};%Ԫ����Ԫ��Ϊ���ļ��ľ���·��()�����Ѱ��ֵ�˳������
fileNum=length(near_fileNames);
%% ����Զ��վ���ݶ�Ӧʱ�̱�
    far_filenum=length(far_fileNames);
    far_timestamp=cell(1,far_filenum);
    for i=1:far_filenum
        tempstr=far_fileNames{i};
        tempstr=strsplit(tempstr,',');
        tempstr=tempstr(7);
        far_timestamp{i}=tempstr{1};
    end
	near_filenum=length(near_fileNames);
    near_timestamp=cell(1,near_filenum);
    for i=1:near_filenum
        tempstr=near_fileNames{i};
        tempstr=strsplit(tempstr,',');
        tempstr=tempstr(7);
        near_timestamp{i}=tempstr{1};
    end
    %% �ҵ���վ����ͬʱ�̵��ļ�
    %timestamp��¼ʱ�̣�ind_far,in_near,��Ӧ�ڸ�ʱ�̵�������far/near_fileNames�е�����.
    [timestamp,ind_far,ind_near]=intersect(far_timestamp,near_timestamp);
    len=length(timestamp);
for i=1:len
    filename1=near_fileNames{ind_near(i)};
    filename2=far_fileNames{ind_far(i)};
  disp(filename1); disp(filename2);
end
%% ��ʱ��
if(1)
delay=zeros(2,len)';
peak_val =zeros(2,len)';
fs = 250000; % ������
fc =22200;%����Ƶ��
for i=1:len
%%��ȡʱ�̵������ļ�
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{ind_far(i)});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{ind_near(i)});
    %time ʱ��
    time =1;
    FarSta=far_ew(1:fs*time);
    NearSta=near_ew(1:fs*time);
    %% �ֱ���������źŵĲ���

    %% ��ƴ�ͨ�˲���,��ȡfc=22200HZ���ź�

    fcuts=[fc-500 fc-100 fc+100 fc+500];
    Ap=1;
    As=50;% ����ͨ�������˥��
    devs=[10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];% ����ƫ����
    mags=[0 1 0];
    [n,Wn,beta,ftype]=kaiserord(fcuts,mags,devs,fs);
    h=fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    %% �˲�
    fdata=filtfilt(h,1,FarSta);
    ndata=filtfilt(h,1,NearSta);
    %% �������ʱ��
    [c,lags]=xcorr(fdata,ndata,'coeff');
    [val_max,ind_max] = max(c);
    [val_min,ind_min] = min(c);
    delay(i,1)=lags(ind_max);
    delay(i,2)=lags(ind_min);
    peak_val(i,1)=val_max;
    peak_val(i,2)=val_min;
end
%%������ʱ�Ӳ�������ط��ֵ
%%��ͼ����
figure;
hold on
plot(peak_val(:,1),'-o');
plot(-peak_val(:,2),'-o');
legend('MAX_Peak_VAL','MIN_Peak_VAl');
figure
hold on
plot(delay(:,1),'-o');
plot(delay(:,2),'-o');
legend('MAX_Delay','MIN_Delay');
end