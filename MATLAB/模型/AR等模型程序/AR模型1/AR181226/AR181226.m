%***4�������˶��������ų�,������,�ٶȴ�С����,�޼��ٶ�����
clear;clc;
%L0��L1,L2 ��Fall�����޸�
V=800;T=0.02;steps=500;
P=100*[0 0;0 1; 2 5; 3 4; 7 3; 9 1];
P=10000*rand(40,2);
theta=[0 60 120 180 240 300 ]';
theta=zeros(40,1);
ang0=[cos(deg2rad(theta)),sin(deg2rad(theta))];
[m,~]=size(P);
for t=1:steps
  P_store(:,:,t)=P;
  for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
  end
  
  for i=1:m
      d=D(:,i);
      ang(i,:)=F1(P(i,1),P(i,2),P);
  end
  %ang=change(ang0,ang);
  ang0=ang;
  P=P+V*ang*T;
  figure(1)
  
  
  plot(P(:,1),P(:,2),'.');
  axis([0 10000 0 10000]);
 
 
  
end
for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end




