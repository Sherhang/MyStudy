function [ plan] = base_min_assign( B)
%y ƥ�����fvalĿ��ֵ��CĿ��ϵ������
% ���㷨������Ϊ��׼
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

%x=bintprog(f,[],[],Aeq,beq);
intcon=1:n*n;
x=intlinprog(f,intcon,[],[],Aeq,beq,lb,ub);
y=reshape(x,n,n);
y=y';
[row ,col]=find(y); %colĬ�ϵ���
plan=row';
  
end



