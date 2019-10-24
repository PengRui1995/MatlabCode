function [EWdata,NSdata]=fnExtEWNSdata(PathName,FileName)
%ExtNSdata=Extraction of EW/NS data,��ȡEW/NSͨ������
%PathName���ļ�����·��
%FileName���ļ�����������չ��


	[file_id,message] = fopen([PathName,FileName],'rb');
	disp(FileName);
	if file_id < 0      %�򿪴���
	   disp(message);
	end
	Rawdatas = fread(file_id,'uint16'); %�����ݴ洢��ʽ��ȡ
	Rawdatas = Rawdatas';               %������ת��
	fclose(file_id);    %16bits���ȣ������ݳ���  
	%�жϵ�ͨ������˫ͨ��
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
	  %  A = NSdata;%ѡȡһ��ͨ������A = EWdata
	  %  B = EWdata;
	end
end