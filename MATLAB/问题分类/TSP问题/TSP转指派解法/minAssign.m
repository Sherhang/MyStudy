function [ plan,y ] = minAssign( C)
%y ƥ�����fvalĿ��ֵ��CĿ��ϵ������
%���ӹ滮��plan���ӹ滮������ʵֵ���룬y���Թ滮��01����
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

%�㷨ѡ��
%x0=rand(n,n);%�ڵ�
% options = optimoptions('linprog','Algorithm','interior-point','Display','final');%�ڵ㷨�����ģ
% options = optimoptions('linprog','Algorithm','active-set','Display','final');%���ι滮���еȹ�ģ
% options = optimoptions('linprog','Algorithm','simplex','Display','final');%�����η���С��ģ
% if n<=100
%     options = optimoptions('linprog','Algorithm','active-set','Display','final')
%     x=linprog(f,[],[],Aeq,beq,lb,ub,x0,options);
% 
% else x=linprog(f,[],[],Aeq,beq,lb,ub);%Ĭ���ڵ㷨
% end
x=linprog(f,[],[],Aeq,beq,lb,ub);%Ĭ���ڵ㷨
y=reshape(x,n,n);
y=y';

plan= gradualMax( y,n);%�̶�̮������

          
end





