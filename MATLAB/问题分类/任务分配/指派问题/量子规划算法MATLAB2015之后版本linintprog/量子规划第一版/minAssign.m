function [ plan,y ] = minAssign( C)
%y 匹配矩阵，fval目标值，C目标系数矩阵
%量子规划，plan量子规划方案，实值编码，y线性规划，01编码
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

%算法选择
%x0=rand(n,n);%内点
% options = optimoptions('linprog','Algorithm','interior-point','Display','final');%内点法，大规模
% options = optimoptions('linprog','Algorithm','active-set','Display','final');%二次规划，中等规模
% options = optimoptions('linprog','Algorithm','simplex','Display','final');%单纯形法，小规模
% if n<=100
%     options = optimoptions('linprog','Algorithm','active-set','Display','final')
%     x=linprog(f,[],[],Aeq,beq,lb,ub,x0,options);
% 
% else x=linprog(f,[],[],Aeq,beq,lb,ub);%默认内点法
% end
x=linprog(f,[],[],Aeq,beq,lb,ub);%默认内点法
y=reshape(x,n,n);
y=y';

plan= gradualMax( y,n);%固定坍缩方案

          
end





