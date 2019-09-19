function [prow,pclo] = gamble( row,clo,m,n,N )
%UNTITLED2 此处显示有关此函数的摘要
%   轮盘赌
rowclo=[row,clo'];
rowclo(N+m)=0;
r=sum(rowclo)*rand();
s=rowclo(1);
t=1;
while(1)
    if r<=s
        break;
    end
    t=t+1;
    s=s+rowclo(t);
end


if(t<=N)
    prow=m;pclo=t;
end 
if(t>N)
    prow=(t-N);pclo=n;
end 

end

