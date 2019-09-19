%**********�������任�������԰������з������������Ž⣬,10*10��ʱ47s******%
clear;
clc;

%% λ��
Fx=500.*[1 5 3 2 9 4 6 7 8]';
Fy=500.*[3 1 9 6 4 5 5 8 6]';
Mx=Fx;
My=Fy;
Tx=500*[4 5 6 7 9 10 16 18 19 ]';
Ty=2000*[3 5 6 8 10 11 13 14 15 ]';
N=9;
%% ���ٸ��ʾ�����в����
% pro=zeros(N);
for i=1:N
    for j=1:N
        pro(i,j)=100000./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
%% �������任��,����ȫ��������߾���
a=1:N;
c=perms(a);
% plan(:,:,factorial(N))=zeros(N);
for i=1:factorial(N)
    plan(:,:,i)=zeros(N);
    for j=1:N
        plan(c(i,j),j,i)=1;
    end
end 
%% �ж��Ƿ�����ظ���
% flag=0;
% for i=1:factorial(N)
%     for j=1:factorial(N)
%         if i~=j
%             if plan(:,:,i)==plan(:,:,j)
%                 flag=1;
%             end
%         end
%     end
% end
%% �����е�������
% gains(factorial(N))=0;
for i=1:factorial(N)
    gains(i)=sum(sum(pro.*threat.*plan(:,:,i)));
end
solution = find(gains==max(max(gains))) 
max=gains(solution)
P=plan(:,:,solution)
[i,j]=find(P==1)