%***，吸引排斥,无中心,速度大小不变,无加速度限制，加入一致性项
clear;clc;
%L0，L1,L2 在Fall里面修改
V=800;T=0.02;steps=1000;
P=100*[0 0;0 1; 2 5; 3 4; 7 3; 9 1];
P=10000*rand(6,2);
theta=[0 0 0 0 0 0 0 ]';
theta=rand(6,1);
ang0=[cos(deg2rad(theta)),sin(deg2rad(theta))];%原始方向
[m,~]=size(P);
for t=1:steps
  P_store(:,:,t)=P;
  for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
  end
 
  %AD方向
  for i=1:m
      d=D(:,i);
      ang1(i,:)=F1(P(i,1),P(i,2),P);
  end
  %一致方向
  
  ang2=F2(P,ang1);
 
  %总方向
  ang=ang1+4*ang2;
  %总方向单位化
 for i=1:m
    if(ang(i,:)~=[0 0]) 
        ang(i,:)=ang(i,:)/norm(ang(i,:));
    end
 end
 
ang0=ang;%原始方向更新
  
  
  P=P+V*ang*T;
  figure(1)
  plot(P(:,1),P(:,2),'.');
  %axis([0 10000 0 10000]);
  hold on
end
for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end




