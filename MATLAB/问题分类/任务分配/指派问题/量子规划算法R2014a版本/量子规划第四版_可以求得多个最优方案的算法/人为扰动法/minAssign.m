function [ Plan,y ] = minAssign(B)
%y 匹配矩阵，fval目标值，B目标系数矩阵
%量子规划，plan量子规划方案，实值编码，y线性规划，01编码
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
Plan= gradualMax( y,n);

      
end







