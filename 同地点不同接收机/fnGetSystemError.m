function [v,err] = fnGetSystemError(DataA,DataB)
%myFun - Description
%
% Syntax: [v,err] = fnGetSystemError(DataA,DataB)
%
% Long description
v=mean(DataA-DataB);
err = (DataA-mean(DataA))./(DataB-mean(DataB))-1;   
end