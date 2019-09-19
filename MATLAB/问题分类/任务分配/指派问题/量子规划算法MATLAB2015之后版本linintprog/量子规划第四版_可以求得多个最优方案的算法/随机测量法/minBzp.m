function [plan,f] = minBzp( B)
%y 匹配矩阵，fval目标值，C目标系数矩阵
% 线性规划算法，有一个问题，取整如果都是0则结果错误
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
intcon=1:n*n;
x=intlinprog(f,intcon,[],[],Aeq,beq,lb,ub);
y=reshape(x,n,n);
y=y';
plan=codeBool2codeVal(y,n);
f=sum(sum(B.*y));
  
end



