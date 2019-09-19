function [plan_unique,y,fout,cou] = minAssign(B,m)
%y 匹配矩阵，fval目标值，B目标系数矩阵
%量子规划，plan量子规划方案，实值编码，y线性规划，01编码
C=B';
f=C(:);
[~,n]=size(C);
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
% [mm1,nn1,~]=find(y>0.1&y<0.7);%自适应搜索步长法，不太好确定
% [~,number]=size(mm1);
% m=number*10;

for i=1:m
    [plan,cou]=qCollapse( y,n);
        plan_store(i,:)=plan;
    fmin(i)=sum(sum(B.*codeVal2codeBool(plan,n)));
     if cou>=n-1;% 优化判断
         break;
     end
end

plan = gradualMax( y,n);%固定坍缩方案
plan_store(i+1,:)= plan;
fmin(i+1)=sum(sum(B.*codeVal2codeBool(plan,n)));
%p=find((fmin-min(fmin))/min(fmin)<=10^-5);%%误差上限等价方案
p=find(fmin==min(fmin));%绝对等价方案
[~,pn]=size(p);
for i=1:pn
    Plan(i,:)=plan_store(p(i),:);
end
plan_unique=unique(Plan,'rows');
fout=min(fmin);         
end





