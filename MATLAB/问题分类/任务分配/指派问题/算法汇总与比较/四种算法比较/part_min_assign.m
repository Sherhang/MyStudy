function [plan] = part_min_assign( C)
% CĿ��ϵ������
% ��֧���編�����㷨��Ҫ��matlabr2014a���������С�
% out��plan �̶��У��к��ǽ����
C=C';
f=C(:);
[m,n]=size(C);
Aeq=zeros(2*n,n*n);
for i=1:n
    Aeq(1:n,1+(i-1)*n:i*n)=eye(n);
end
for i=1:n
    Aeq(n+i,1+(i-1)*n:i*n)=ones(1,n);%һ��n��Ԫ��Ϊ1����
end

beq=ones(2*n,1);%��ʽԼ���Ҷ���
lb=zeros(n*n,1);%����ʽԼ�����
ub=ones(n*n,1);%����ʽԼ���Ҷ�

x=bintprog(f,[],[],Aeq,beq);

y=reshape(x,n,n);
y=y';
y=round(y);%ȡ��
 
[row ,col]=find(y); %colĬ�ϵ���
plan=row';
end



