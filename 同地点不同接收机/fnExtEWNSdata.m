function [EWdata,NSdata]=fnExtEWNSdata(PathName,FileName)
%ExtNSdata=Extraction of EW/NS data,提取EW/NS通道数据
%PathName，文件所在路径
%FileName，文件名，包含扩展名


	[file_id,message] = fopen([PathName,FileName],'rb');
	disp(FileName);
	if file_id < 0      %打开错误
	   disp(message);
	end
	Rawdatas = fread(file_id,'uint16'); %按数据存储方式读取
	Rawdatas = Rawdatas';               %对数据转置
	fclose(file_id);    %16bits长度，即数据长度  
	%判断单通道还是双通道
	if(strcmp(FileName(1:4),'EWNS'))
		j = 1;
		L = length(Rawdatas);
		EWdata = zeros(1,L/2);
		NSdata = zeros(1,L/2);
		for i=1:2:L
			EWdata(j) = Rawdatas(i);
			NSdata(j) = Rawdatas(i+1);
			j = j+1;
		end
	  %  A = NSdata;%选取一个通道，或A = EWdata
	  %  B = EWdata;
	end
end