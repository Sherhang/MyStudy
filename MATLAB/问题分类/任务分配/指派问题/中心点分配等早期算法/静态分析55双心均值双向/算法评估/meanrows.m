Fx=fx(:,t);
Fy=fy(:,t);
Mx=mx(:,t);
My=my(:,t);
Tx=tx(:,t);
Ty=ty(:,t);
%% 生成威胁矩阵
for i=1:N
    for j=1:N
        pro1(i,j)=100./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat1=pro1;
promean=(mean(pro1))';
threat1=threat1';
threat1mean=(mean(threat1))';

[temp,Tsort]=sort(threat1mean,'descend');
[temp,Msort]=sort(promean,'descend');
Mplan=sortrows([Msort,Tsort],1);
%% 求收益
for i=1:N
    for j=1:N
        pro1(i,j)=100./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat1=pro1;
plan2(:,:)=zeros(N);
for j=1:N
        plan2(Mplan(j,1),Mplan(j,2))=1;
end
Mmax=sum(sum(pro1.*threat1.*plan2));