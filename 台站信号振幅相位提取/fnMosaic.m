function data=fnMosaic(sdata,indarray,nSeg)
	% sdata ԭʼ����
	% indarray ����������������
	% nSeg ÿ�ΰ������������
	len_data = length(indarray)*nSeg;
	data = zeros(1,len_data);
	for i = 1:length(indarray)
		data((i-1)*nSeg+1:i*nSeg)=sdata((indarray(i)-1)*nSeg+1:indarray(i)*nSeg);
	end
end