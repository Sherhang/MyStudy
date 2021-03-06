% 量子优化算法求最小指派问题
% 输入m*n的一个矩阵，输出plan 2*n , 第一行对应目标序列，第二行对应执行体序列
function plan = quantumMinAssign(matrix)
[m,n] = size(matrix);
% 列数小于行数，扩充列数，扩充值为原矩阵的最大值
inf = max(max(matrix));
N = max(m,n);
mat = inf*ones(N,N);  % 新矩阵
if m < n
    mat(1:m,:) = matrix;
end
if m > n
    mat(:,1:n) = matrix;
end
plan = qMinAssign(mat);
if m < n   
    for i=1:n
        if plan(2,i) > m
            plan(2,i) = 0;
        end
    end
end
if m > n
    for i=1:m
        if plan(1,i) > n
            plan(1,i) = 0;
        end
    end
    plan = plan(:,1:n);
end

end



function plan = qMinAssign(C)

%inputs:C目标系数矩阵，只能是方阵。非方阵需要转换。
%量子规划，plan量子规划方案，实值编码，y线性规划，01编码，这里取消了y的输出
%该方法采用固定方案，只能求得一个结果。
C=C';
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

function plan = gradualMax( a,N)
%  逐次取最大
Msort = zeros(1,N);
Tsort = zeros(1,N);
for j=1:N
    [row ,clo]=find(a==max(max(a)),1);
    Msort(j)=row;    % 这一步是为了防止出现两个最大值，只要第一个
    Tsort(j)=clo;
    a(Msort(j),:)=0;
    a(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
plan(2,:) = temp(:,1)';
plan(1,:) = 1:N;
end

