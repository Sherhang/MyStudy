%********逐次取最大
pro1=pro;
threat1=threat;
for j=1:N
    a=pro1.*threat1;
    [row ,clo]=find(a==max(max(a)));
    Msort(j)=row(1);% 这一步是为了防止出现两个最大值，只要第一个
    Tsort(j)=clo(1);
    pro1(Msort(j),:)=0;
    pro1(:,Tsort(j))=0;
    threat1(Msort(j),:)=0;
    threat1(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
Gplan=temp(:,1)';
[~,gp,~]=intersect(c,Gplan,'rows'); % 位置

gplan(:,:)=codeVal2codeBool(Gplan,N);
Gmaxval(t)=sum(sum(pro.*threat.*gplan));

