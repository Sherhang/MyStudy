Fx=fx(:,t);
Fy=fy(:,t);
Mx=mx(:,t);
My=my(:,t);
Tx=tx(:,t);
Ty=ty(:,t);
%% ˫�ĵ����
Fox=mean(Fx);
Foy=mean(Fy);
Tox=mean(Tx);
Toy=mean(Ty);
pro1=100000./sqrt((Fx-Tox).^2+(Fy-Toy).^2);
threat1=100000./sqrt((Tx-Fox).^2+(Ty-Foy).^2);
[temp,Tsort]=sort(threat1,'descend');
[temp,Msort]=sort(pro1,'descend');
Dplan=sortrows([Msort,Tsort],1);
%% ������
for i=1:N
    for j=1:N
        pro(i,j)=100./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
plan2(:,:)=zeros(N);
for j=1:N
        plan2(j,Dplan(j,2))=1;
end
Dmax=sum(sum(pro.*threat.*plan2));