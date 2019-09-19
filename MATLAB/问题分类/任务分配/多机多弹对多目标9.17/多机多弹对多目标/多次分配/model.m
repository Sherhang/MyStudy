function [orderm,ordern,V01,Val]=model(m,mNum,n,nV,Pm,Pn)
%输入：我方载机数目m，各载机携带导弹数目mNum[1 2 3 2 1]。敌机数目n,价值矩阵nV
%位置Pm,Pn，角度Am,An，速度V,m,Vn
%输出：分配序列order，分配次数NumofAssign，优势矩阵Val


% m=5;
% mNum=[3 2 4 3 2 3];
% n=10;nV=diag([1,1,10,1,1,1,1,1,1,5]);
% Pm=rand(m,2);Pn=rand(n,2);

%导弹分配序列
k=1;orderm=[];
for i=1:m
    for j=1:mNum(i)
        orderm(k)=i;
        k=k+1;
    end
end

%目标序列
nVo=nV;
nVo(find(nVo>1))=2;
k=1;ordern=[];
for i=1:n
    for j=1:nVo(i,i)
        ordern(k)=i;
        k=k+1;
    end
end
%优势矩阵
for i=1:m
    for j=1:n
        Val(i,j)=10/(sqrt((Pm(i,1)-Pn(j,1)).^2+(Pm(i,2)-Pn(j,2)).^2));
    end
end

%Val=Val*nV;
 
% 广义优势矩阵
V01=[];
V01=Val;
V01=V01(orderm,:);
%广义补足优势矩阵

