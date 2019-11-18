
function [amp,phase1,phase2]=vlfMSKDemodulation_cl2(fs,fc,fb,A)

DataL = length(A);
%% 带通滤波器设计中心频率fc,带宽2000hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcuts = [fc-6000 fc-300 fc+300 fc+6000];%[fc-500 fc-180 fc+180 fc+500];%[fc-1000 fc-300 fc+300 fc+1000];
Ap = 1;
As = 40;     % 定义通带及阻带衰减
devs = [10^(-As/20),(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; % 计算偏移量
mags = [0 1 0];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
h_LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d1=ceil(mean(grpdelay(h_LP,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data=filter(h_LP,1,[A zeros(1,d1)]);
data=data(d1+1:end);
%data = filtfilt(h_LP,1,A);      %零相位滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%
fn = 250000;            %每秒总采样点数
dt = 1/fs;
tend = DataL/fs;        %时间 
msk_data = data(1:fn*tend);
% tn  = start_time:dt:start_time+tend-dt;
tn  = 0:dt:tend-dt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         利用软件DDS 生成理想的频率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [sin_osci,cos_osci, tn] = dds_generate(fc, fs, Bits, 10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MSK数字带通解调仿真
%   正交 相干 解调
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id = msk_data.*cos(2*pi*fc*tn);           %同相支路
Qd = msk_data.*cos(2*pi*fc*tn+pi/2);        %正交支路
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FIR滤波器 降采样时的抗混叠滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcut_lp = [5000 25000];
Ap=1;
As=40;   	
devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)];	
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs);
LP_anti = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d2=ceil(mean(grpdelay(LP_anti,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_anti=filter(LP_anti,1,[Id zeros(1,d2)]);
Id_anti=Id_anti(d2+1:end);
Qd_anti=filter(LP_anti,1,[Qd zeros(1,d2)]);
Qd_anti=Qd_anti(d2+1:end);
%Id_anti = filtfilt(LP_anti,1,Id);        %filter data
%Qd_anti = filtfilt(LP_anti,1,Qd);        %filter data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        resample   DeCIC rate = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
down_sample_rate = 1;
Id_D = Id_anti(1:down_sample_rate:end);
Qd_D = Qd_anti(1:down_sample_rate:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    获得基带滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIR滤波器
fcut_lp = [200 550];
Ap=1;
As=40;    
devs=[(10^(Ap/20)-1)/(10^(Ap/20)+1),10^(-As/20)]; 
mags=[1 0];
[n,Wn,beta,ftype]=kaiserord(fcut_lp,mags,devs,fs/down_sample_rate);
LP = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
d3=ceil(mean(grpdelay(LP,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Id_fiter=filter(LP,1,[Id_D zeros(1,d3)]);
Id_fiter=Id_fiter(d3+1:end);
Qd_fiter=filter(LP,1,[Qd_D zeros(1,d3)]);
Qd_fiter=Qd_fiter(d3+1:end);
%Id_fiter = filtfilt(LP,1,Id_D);  %信号通过滤波器
%Qd_fiter = filtfilt(LP,1,Qd_D);  %信号通过滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   相对于200HZ波特率而言，降采样至1000HZ仍是过采样
%   resample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rate_d = 1;
Id_after_d = Id_fiter(1:rate_d:end);
Qd_after_d = Qd_fiter(1:rate_d:end);

%tp = tn(1:rate_d*down_sample_rate:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       求解相位与幅度
%       相位变化范围：-180deg~+180deg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amp = Id_after_d.^2 + Qd_after_d.^2;
amp_s = 2*sqrt(amp);
amp_ad = 20*log10(5*amp_s/65535);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Len_ReN = length(amp_ad);
Nb = 200;                        %码元波特率 
fn_d = fn/down_sample_rate/rate_d;%降采样之后的最终采样率

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %FFT 计算初相
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amp_deal = amp_ad;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base_c = Id_after_d+sqrt(-1)*Qd_after_d;
base_c = base_c.*base_c;

base_cfft=fft(base_c);
%etime(clock,t0)
%figure;plot(abs(base_cfft),'-o');title(FileName);%hold on;plot(magI);


%% 输出幅度相位
amp1=mean(amp_deal);
N=length(base_c);%fft点数
fs2=fn_d;
%point=round([100/(fs2/N)+1 N-100/(fs2/N)+1]);%点
point=round([fb/2/(fs2/N)+1 N-fb/2/(fs2/N)+1]);
fftamp=sqrt(abs(base_cfft(point)));
fftphase=angle(base_cfft(point));
phase1=fftphase(1);
phase2=fftphase(2);
amp = amp1;
%disp(amp1);disp(fftamp);disp(fftphase);
%figure;plot(abs(fft(msk_data(1:250000))),'-o')
%% 
% testc=Id_after_d+sqrt(-1)*Qd_after_d;
% magtestc=20*log(abs(fftshift(fft(testc))));
% figure;plot(magtestc);

% testc=Id_after_d+sqrt(-1)*Qd_after_d;
% magtestc=20*log(abs(fft(testc)));
% figure;plot(magtestc);

%% 输出滤波器参数
% h=h_LP;
% fileID=fopen('h1.bin','w');
% fwrite(fileID,h,'double');
% fclose(fileID);
% 
% h=LP_anti;
% fileID=fopen('h2.bin','w');
% fwrite(fileID,h,'double');
% fclose(fileID);
% 
% h=LP;
% fileID=fopen('h3.bin','w');
% fwrite(fileID,h,'double');
% fclose(fileID);
% hh1=h_LP';
% fid=fopen('hh1.txt','w');
% [b1,b2]=size(hh1);
% for i=1:b1
%     for j=1:b2
%        fprintf(fid,'%f',hh1(i,j));
%     end
%    fprintf(fid,'\n');
% end
% fclose(fid);
% 
% hh2=LP_anti';
% fid=fopen('hh2.txt','w');
% [b1,b2]=size(hh2);
% for i=1:b1
%     for j=1:b2
%        fprintf(fid,'%f',hh2(i,j));
%     end
%    fprintf(fid,'\n');
% end
% fclose(fid);
% 
% hh3=LP';
% fid=fopen('hh3.txt','w');
% [b1,b2]=size(hh3);
% for i=1:b1
%     for j=1:b2
%        fprintf(fid,'%f',hh3(i,j));
%     end
%    fprintf(fid,'\n');
% end
% fclose(fid);

end