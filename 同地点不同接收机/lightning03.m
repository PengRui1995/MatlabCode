clear all;close all ;clc;
%%ѡ����վ�ļ���
%ѡ��Զվ�ļ���
far_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','��ѡ��Զվ�ļ���');
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
    disp(filepath);%��ʾ·����ע�͵�����ʾ
end
%%ѡ���վ�ļ���
near_dirpath = uigetdir('C:\Users\P.R\Desktop\vlfdata\20170501','��ѡ��Զվ�ļ���');
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
%% ��ȡͬͨ��̨վ��NS���ݡ�

for i=[1,12]
%disp(timestamp(i));
  %% ��ȡͬʱ����̨վ��NSͨ������
    [far_ew,far_ns]=fnExtEWNSdata([far_dirpath,'\'],far_fileNames{ind_far(i)});
    [near_ew,near_ns]=fnExtEWNSdata([near_dirpath,'\'],near_fileNames{ind_near(i)});
    %%
    fs=250000;
    fc=22200;
   [delay(1,i),delay(2,i),c(1,i),c(2,i)]=fnGetDelay(far_ew(1:fs),near_ew(1+fs*1:fs*2),fs,fc);
  % [delay(1,i),delay(2,i),c(1,i),c(2,i)]=fnGetDelay(far_ew(1:fs),near_ew(1:fs*1),fs,fc);
end
figure
hold on
plot(delay(1,:),'-ro');
plot(delay(2,:),'-go');
legend('delay1','delay2');
figure
hold on
plot(c(1,:),'-r*');
plot(c(2,:),'-g*');
legend('��ֵ','��ֵ');

