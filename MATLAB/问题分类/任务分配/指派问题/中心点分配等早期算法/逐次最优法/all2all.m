%% �������任��,����ȫ��������߾���

% plan(:,:,factorial(N))=zeros(N);
for i=1:factorial(N)
    plan(:,:,i)=codeVal2codeBool(c(i,:),N);
end 

%% �����е�������
% gains(factorial(N))=0;
for i=1:factorial(N)
    gains(i)=sum(sum(pro.*threat.*plan(:,:,i)));
end
solution = find(gains==max(max(gains)));%ȫ�����Ž��ڱ����е�λ��
Aplan=c(solution(1),:);%ֻҪ��һ��
Amaxval(t)=sum(sum(pro.*threat.*plan(:,:,solution(1))));