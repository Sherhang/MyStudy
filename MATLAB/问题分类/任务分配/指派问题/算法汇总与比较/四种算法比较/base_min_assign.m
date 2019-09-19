function [ plan] = base_min_assign( B)
%y 匹配矩阵，fval目标值，C目标系数矩阵
% 此算法可以作为标准
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

%x=bintprog(f,[],[],Aeq,beq);
intcon=1:n*n;
x=intlinprog(f,intcon,[],[],Aeq,beq,lb,ub);
y=reshape(x,n,n);
y=y';
[row ,col]=find(y); %col默认递增
plan=row';
  
end



