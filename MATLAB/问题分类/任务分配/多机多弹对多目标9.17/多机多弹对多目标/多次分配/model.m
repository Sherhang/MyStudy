function [orderm,ordern,V01,Val]=model(m,mNum,n,nV,Pm,Pn)
%���룺�ҷ��ػ���Ŀm�����ػ�Я��������ĿmNum[1 2 3 2 1]���л���Ŀn,��ֵ����nV
%λ��Pm,Pn���Ƕ�Am,An���ٶ�V,m,Vn
%�������������order���������NumofAssign�����ƾ���Val


% m=5;
% mNum=[3 2 4 3 2 3];
% n=10;nV=diag([1,1,10,1,1,1,1,1,1,5]);
% Pm=rand(m,2);Pn=rand(n,2);

%������������
k=1;orderm=[];
for i=1:m
    for j=1:mNum(i)
        orderm(k)=i;
        k=k+1;
    end
end

%Ŀ������
nVo=nV;
nVo(find(nVo>1))=2;
k=1;ordern=[];
for i=1:n
    for j=1:nVo(i,i)
        ordern(k)=i;
        k=k+1;
    end
end
%���ƾ���
for i=1:m
    for j=1:n
        Val(i,j)=10/(sqrt((Pm(i,1)-Pn(j,1)).^2+(Pm(i,2)-Pn(j,2)).^2));
    end
end

%Val=Val*nV;
 
% �������ƾ���
V01=[];
V01=Val;
V01=V01(orderm,:);
%���岹�����ƾ���

