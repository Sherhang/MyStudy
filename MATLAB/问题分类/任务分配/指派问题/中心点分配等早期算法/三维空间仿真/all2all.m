%% 分配矩阵变换法,利用全排列求决策矩阵

% plan(:,:,factorial(N))=zeros(N);
for i=1:factorial(N)
    plan(:,:,i)=codeVal2codeBool(c(i,:),N);
end 

%% 求所有的总收益
% gains(factorial(N))=0;
for i=1:factorial(N)
    gains(i)=sum(sum(pro.*threat.*plan(:,:,i)));
end
solution = find(gains==max(max(gains)));%全体最优解在编码中的位置
Aplan=c(solution(1),:);%只要第一个
Amaxval(t)=sum(sum(pro.*threat.*plan(:,:,solution(1))));