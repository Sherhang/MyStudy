function [num]=calnum(pop)
[px,py]=size(pop);
i=1;
m=0;
n=0;
for i=1:py
if(pop(i)==1)
m=m+1;
end
if(pop(i)==2)
n=n+1;
end
end
num=[m n];


