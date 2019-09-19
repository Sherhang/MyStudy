function [ plan,gains,c] =all2all( a,N )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

c=perms(1:N);%全排列
for i=1:factorial(N)
    matrix(:,:,i)=codeVal2codeBool(c(i,:),N);
end 

for i=1:factorial(N)
    gains(i)=sum(sum(a.*matrix(:,:,i)));
end

solution = find(gains==max(max(gains)));%全体最优解在编码中的位置
plan=c(solution(1),:);%只要第一个
end



