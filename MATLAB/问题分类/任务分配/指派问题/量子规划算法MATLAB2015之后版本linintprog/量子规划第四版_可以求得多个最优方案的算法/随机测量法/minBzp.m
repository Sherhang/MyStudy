function [plan,f] = minBzp( B)
%y ƥ�����fvalĿ��ֵ��CĿ��ϵ������
% ���Թ滮�㷨����һ�����⣬ȡ���������0��������
C=B';
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
intcon=1:n*n;
x=intlinprog(f,intcon,[],[],Aeq,beq,lb,ub);
y=reshape(x,n,n);
y=y';
plan=codeBool2codeVal(y,n);
f=sum(sum(B.*y));
  
end



