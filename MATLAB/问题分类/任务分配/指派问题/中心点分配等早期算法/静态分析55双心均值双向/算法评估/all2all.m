Fx=fx(:,t);
Fy=fy(:,t);
Mx=mx(:,t);
My=my(:,t);
Tx=tx(:,t);
Ty=ty(:,t);
%%
for i=1:N
    for j=1:N
        pro(i,j)=100./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
%% �������任��,����ȫ��������߾���
a=1:N;
c=perms(a);
% plan(:,:,factorial(N))=zeros(N);
for i=1:factorial(N)
    plan(:,:,i)=zeros(N);
    for j=1:N
        plan(j,c(i,j),i)=1;
    end
end 

%% �����е�������
% gains(factorial(N))=0;
for i=1:factorial(N)
    gains(i)=sum(sum(pro.*threat.*plan(:,:,i)));
end
solution = find(gains==max(max(gains))) ;

P=plan(:,:,solution);
[i,j]=find(P==1);
Aplan=sortrows([i,j],1);