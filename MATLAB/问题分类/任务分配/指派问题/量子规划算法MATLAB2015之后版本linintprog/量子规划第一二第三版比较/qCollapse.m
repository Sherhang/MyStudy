function [ plan,count ] = qCollapse (p,N)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
pmax=0.7;%阈值
count=0;%优化作用，当count==n时直接进行一次测量
for j=1:N
    
    [row ,clo]=find(p==max(max(p)));
    m=row(1);n=clo(1);% 这一步是为了防止出现两个最大值，只要第一个
    if p(m,n)>pmax
        Msort(j)=row(1);% 这一步是为了防止出现两个最大值，只要第一个
        Tsort(j)=clo(1);
        p(Msort(j),:)=0;
        p(:,Tsort(j))=0;
        count=count+1;
    
    else 
        row1=p(m,:);clo1=p(:,n);
        [prow,pclo] = gamble( row1,clo1,m,n,N );
        Msort(j)=prow;
        Tsort(j)=pclo;
        p(Msort(j),:)=0;
        p(:,Tsort(j))=0;
    end
    
   
end
temp=sortrows([Msort',Tsort'],2);
plan=temp(:,1)';

end

