%*********双心点算法********%
clear;
clc;

%% 位置
Fx=500.*[1 5 3 2 9 4 6 7 8]';
Fy=500.*[3 1 9 6 4 5 5 8 6]';
Mx=Fx;
My=Fy;
Tx=500*[4 5 6 7 9 10 16 18 19 ]';
Ty=2000*[3 5 6 8 10 11 13 14 15 ]';
N=9;
%% 击毁概率矩阵，威胁矩阵
% pro=zeros(N);
for i=1:N
    for j=1:N
        pro(i,j)=100000./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
threat=pro;
%% 双心点决策
Fox=mean(Fx);
Foy=mean(Fy);
Tox=mean(Tx);
Toy=mean(Ty);
pro1=100000./sqrt((Fx-Tox).^2+(Fy-Toy).^2);
threat1=100000./sqrt((Tx-Fox).^2+(Ty-Foy).^2);
[temp,Tsort]=sort(threat1,'descend');
[temp,Msort]=sort(pro1,'descend');