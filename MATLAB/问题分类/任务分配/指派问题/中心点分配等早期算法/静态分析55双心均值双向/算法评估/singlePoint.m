Fx=fx(:,t);
Fy=fy(:,t);
Mx=mx(:,t);
My=my(:,t);
Tx=tx(:,t);
Ty=ty(:,t);
%% 中心点决策
ox=mean(Fx)/2+mean(Tx)/2;
oy=mean(Fy)/2+mean(Ty)/2;
pro1=100000./sqrt((Fx-ox).^2+(Fy-oy).^2);
threat1=100000./sqrt((Tx-ox).^2+(Ty-oy).^2);
[temp,Tsort]=sort(threat1,'descend');
[temp,Msort]=sort(pro1,'descend');
Splan=sortrows([Msort,Tsort],1);
%% 求收益
for i=1:N
    for j=1:N
        pro(i,j)=100./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
plan2(:,:)=zeros(N);
for j=1:N
        plan2(j,Splan(j,2))=1;
end
Smax=sum(sum(pro.*threat.*plan2));