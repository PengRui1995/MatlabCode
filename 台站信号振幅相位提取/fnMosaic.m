function data=fnMosaic(sdata,indarray,nSeg)
	% sdata 原始数据
	% indarray 保留段引索，升序
	% nSeg 每段包含采样点个数
	len_data = length(indarray)*nSeg;
	data = zeros(1,len_data);
	for i = 1:length(indarray)
		data((i-1)*nSeg+1:i*nSeg)=sdata((indarray(i)-1)*nSeg+1:indarray(i)*nSeg);
	end
end