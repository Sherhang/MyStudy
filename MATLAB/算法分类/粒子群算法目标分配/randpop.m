%�������һ��������,���ֵΪsize
function [randintger]=randpop(size)
k=1;
while (k>0)
a=randperm(size);
i=round(rand*size);
if(i~=0)
break;
end
end
randintger=a(i);
