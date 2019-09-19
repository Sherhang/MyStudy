%*********���ĵ��㷨********%
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
%% ���ĵ����
ox=mean(Fx,Tx);
oy=mean(Ey,Ty);
pro1=100000./sqrt((Fx-ox).^2+(Fy-oy).^2);
threat1=100000./sqrt((Tx-ox).^2+(Ty-oy).^2);
[temp,Tsort]=sort(threat1,'descend');
[temp,Msort]=sort(pro1,'descend');