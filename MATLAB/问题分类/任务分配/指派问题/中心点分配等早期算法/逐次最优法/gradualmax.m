%********���ȡ���
pro1=pro;
threat1=threat;
for j=1:N
    a=pro1.*threat1;
    [row ,clo]=find(a==max(max(a)));
    Msort(j)=row(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
    Tsort(j)=clo(1);
    pro1(Msort(j),:)=0;
    pro1(:,Tsort(j))=0;
    threat1(Msort(j),:)=0;
    threat1(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
Gplan=temp(:,1)';
[~,gp,~]=intersect(c,Gplan,'rows'); % λ��

gplan(:,:)=codeVal2codeBool(Gplan,N);
Gmaxval(t)=sum(sum(pro.*threat.*gplan));

