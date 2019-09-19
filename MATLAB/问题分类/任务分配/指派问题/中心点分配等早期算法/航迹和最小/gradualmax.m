%********逐次取最大

%pro1=max(max(pro))-pro;
dis1=max(max(dis))-dis;
for j=1:N
    a=dis1;
    [row ,clo]=find(a==max(max(a)));
    Msort(j)=row(1);% 这一步是为了防止出现两个，只要第一个
    Tsort(j)=clo(1);
    dis1(Msort(j),:)=0;
    dis1(:,Tsort(j))=0;
    threat1(Msort(j),:)=0;
    threat1(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
Gplan=temp(:,1)';
[~,gp,~]=intersect(c,Gplan,'rows'); % 位置
gplan(:,:)=codeVal2codeBool(Gplan,N);
Gminval(t)=sum(sum(dis.*gplan));

