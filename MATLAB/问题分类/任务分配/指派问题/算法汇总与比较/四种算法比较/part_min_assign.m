function [plan] = part_min_assign( C)
% C目标系数矩阵
% 分支定界法，该算法需要在matlabr2014a环境下运行。
% out：plan 固定列，行号是结果。
C=C';
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

x=bintprog(f,[],[],Aeq,beq);

y=reshape(x,n,n);
y=y';
y=round(y);%取整
 
[row ,col]=find(y); %col默认递增
plan=row';
end



