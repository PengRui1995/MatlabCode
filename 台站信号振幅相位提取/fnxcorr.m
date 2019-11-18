function  delay=fnxcorr(near,far,step_len)
%near 		领先项
%far  		滞后项
%step_len 	分段步长
%delay		各段时延
	len=min([length(near),length(far)]);
	seg_num=fix(len/step_len);
	delay=zeros(1,seg_num);
	lags=1;
	for j=1:seg_num
		fx=near(step_len*(j-1)+1:step_len*j);
		fy=far(step_len*(j-1)+1:step_len*j);
		x=fx-mean(fx);
		y=fy-mean(fy);
		dif=zeros(1,2000);
		for i=1:3000
			len_y=length(y);
			temp_y=y(i+1:end);
			len_temp=length(temp_y);
			temp_x=x(1:len_temp);
			dif(i)=mean(abs(temp_x-temp_y));
		end
		[value,ind]=min(dif);
		delay(j)=ind;
		%disp(['delay',num2str(j),'=',num2str(ind)]);
		temp_y=fy(ind+1:end);
		temp_x=fx(1:length(temp_y));
		% figure
		% hold on
		% plot(temp_x,'b');
		% plot(temp_y,'r');
	end

end