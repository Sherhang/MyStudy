clear
clc
row=[0.7 0.1 0.2];clo=[0.15 0.6 0.25]';N=3;;m=2;n=1;
per=0;

rowclo=[row,clo'];
rowclo(N+m)=0;

for i=1:1000
r=sum(rowclo())*rand();

s=rowclo(1);
t=1;
while(1)
    if r<=s
        break;
    end
    t=t+1;
    s=s+rowclo(t);
end
if t==1
    per=per+1;
end
end

if(t<=N)
    prow=m;pclo=t;
end 
if(t>N)
    prow=(t-N);pclo=n;
end 
[r,prow,pclo,t];  
per=per/1000
    
    
    


