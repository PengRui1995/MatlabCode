%%���־�����㷽�������Ĳ���ֵ
% clear all;
% close all;
% clc;
% MS=[0,0];
% len =4;
% BS = zeros(len,2);
% BS(:,1)= rand(len,1)*180-90;
% BS(:,2)= rand(len,1)*360-180;
% Dis=zeros(length(BS),2);
% for i =1:len
%     Dis(i,1)=fnGetDistance(MS,BS(i,:),'e');
%     Dis(i,2)=fnGetDistance(MS,BS(i,:),'h');
% end
% err =abs(Dis(:,1)-Dis(:,2));
% err_max =max(err);%����100000�κ�õ��Ľ��Ϊ21.0593KM.
disp('running task01');