function fake=fnfake(real)
%���������ԭ���������Ե�����
L=length(real);
fake=zeros(1,L);
for i=2:L
	if(real(i)>real(i-1))
		fake(i)=fake(i-1)+1;
		else
		fake(i)=fake(i-1)-1;
	end
end

end