function [plan_unique,y,fout,cou] = minAssign(B,m)
%y ƥ�����fvalĿ��ֵ��BĿ��ϵ������
%���ӹ滮��plan���ӹ滮������ʵֵ���룬y���Թ滮��01����
C=B';
f=C(:);
[~,n]=size(C);
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
% [mm1,nn1,~]=find(y>0.1&y<0.7);%����Ӧ��������������̫��ȷ��
% [~,number]=size(mm1);
% m=number*10;

for i=1:m
    [plan,cou]=qCollapse( y,n);
        plan_store(i,:)=plan;
    fmin(i)=sum(sum(B.*codeVal2codeBool(plan,n)));
     if cou>=n-1;% �Ż��ж�
         break;
     end
end

plan = gradualMax( y,n);%�̶�̮������
plan_store(i+1,:)= plan;
fmin(i+1)=sum(sum(B.*codeVal2codeBool(plan,n)));
%p=find((fmin-min(fmin))/min(fmin)<=10^-5);%%������޵ȼ۷���
p=find(fmin==min(fmin));%���Եȼ۷���
[~,pn]=size(p);
for i=1:pn
    Plan(i,:)=plan_store(p(i),:);
end
plan_unique=unique(Plan,'rows');
fout=min(fmin);         
end





