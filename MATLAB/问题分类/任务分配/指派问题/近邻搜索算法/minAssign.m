function [ plan ] = minAssign( C)
%y ƥ�����fvalĿ��ֵ��CĿ��ϵ������
% ���Թ滮�㷨����һ�����⣬ȡ���������0��������
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
x=linprog(f,[],[],Aeq,beq,lb,ub);
% x=bintprog(f,[],[],Aeq,beq);
y=reshape(x,n,n);
y=y';
plan= gradualMax( y,n);

%y=round(y);%ȡ��
% sol=zeros(n,n);
% for i=1:n
%     for j=1:n
%         if y(i,j)==1
%             sol(i,j)=C(i,j);
%         end
%     end
% end
% fval=sum(sol(:));           
end





