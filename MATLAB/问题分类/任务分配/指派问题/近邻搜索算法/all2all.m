function [ plan,gains,c] =all2all( a,N )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

c=perms(1:N);%ȫ����
for i=1:factorial(N)
    matrix(:,:,i)=codeVal2codeBool(c(i,:),N);
end 

for i=1:factorial(N)
    gains(i)=sum(sum(a.*matrix(:,:,i)));
end

solution = find(gains==max(max(gains)));%ȫ�����Ž��ڱ����е�λ��
plan=c(solution(1),:);%ֻҪ��һ��
end



