%**********分配矩阵变换法，可以包含所有方案，理论最优解，,10*10用时47s******%
clear;
clc;

%% 位置
Fx=500.*[1 5 3 2 9 4 6 7 8]';
Fy=500.*[3 1 9 6 4 5 5 8 6]';
Mx=Fx;
My=Fy;
Tx=500*[4 5 6 7 9 10 16 18 19 ]';
Ty=2000*[3 5 6 8 10 11 13 14 15 ]';
N=9;
%% 击毁概率矩阵，威胁矩阵
% pro=zeros(N);
for i=1:N
    for j=1:N
        pro(i,j)=100000./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
%% 分配矩阵变换法,利用全排列求决策矩阵
a=1:N;
c=perms(a);
% plan(:,:,factorial(N))=zeros(N);
for i=1:factorial(N)
    plan(:,:,i)=zeros(N);
    for j=1:N
        plan(c(i,j),j,i)=1;
    end
end 
%% 判断是否存在重复项
% flag=0;
% for i=1:factorial(N)
%     for j=1:factorial(N)
%         if i~=j
%             if plan(:,:,i)==plan(:,:,j)
%                 flag=1;
%             end
%         end
%     end
% end
%% 求所有的总收益
% gains(factorial(N))=0;
for i=1:factorial(N)
    gains(i)=sum(sum(pro.*threat.*plan(:,:,i)));
end
solution = find(gains==max(max(gains))) 
max=gains(solution)
P=plan(:,:,solution)
[i,j]=find(P==1)