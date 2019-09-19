Val=rand(N,N);%s随机测试
Val=round(100000*Val)/100000;
     Val(find(Val>0.98))=0.98;
     Val(find(Val<0.2))=0.2;
B=max(max(Val))-Val;

C=B';
f=C(:);
[m,n]=size(C);
Aeq=zeros(2*n,n*n);
for i=1:n
    Aeq(1:n,1+(i-1)*n:i*n)=eye(n);
end
for i=1:n
    Aeq(n+i,1+(i-1)*n:i*n)=ones(1,n);%一行n列元素为1矩阵
end

beq=ones(2*n,1);%等式约束右端项
lb=zeros(n*n,1);%不等式约束左端
ub=ones(n*n,1);%不等式约束右端
x=linprog(f,[],[],Aeq,beq,lb,ub);
% x=bintprog(f,[],[],Aeq,beq);
y=reshape(x,n,n);
y=y';


for i=1:n
    [plan,cou]=qCollapse( y,n);
        plan_store(i,:)=plan;
    fmin(i)=sum(sum(B.*codeVal2codeBool(plan,n)));
    if cou==n
        break;
    end
end
p=find(fmin==min(fmin));
Plan=plan_store(p(1),:);

          


