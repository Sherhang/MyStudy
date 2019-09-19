%***，吸引排斥,无中心,速度大小不变,加速度限制
clear;clc;
flagStop=false;
%L0，L1,L2 在F1里面修改
V=800;T=0.02;steps=1000;omiga=0;
P=100*[0 0;0 1; 0 2; 0 5; 0 7; 0 8]+6000;
Pt=[6000 2000];
%P=100*rand(6,2)+1000;
P(:,1)=zeros(6,1);
theta=30+rand(6,1)*20;
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
    
      ang1(i,:)=F1(P(i,1),P(i,2),P);
  end
  
  %目标方向
  ang3=F3(Pt(1),Pt(2),P);
  %权重
  w=weight(Pt(1),Pt(2),P);
  %一致方向
  ang2=F2(P,ang3+ang0);
  %额外吸引
  ang4=F4(Pt(1),Pt(2),P);
  %总方向
  
  ang=ang1+(ang2+diag(w')*ang3)+10*ang4;
  %总方向单位化
 for i=1:m
    if(ang(i,:)~=[0 0]) 
        ang(i,:)=ang(i,:)/norm(ang(i,:));
    end
 end
ang = change( ang0,ang );
ang=stop(ang,Pt(1),Pt(2),P);
for i=1:m
    if ang(i,:)==[0 0] flagStop=true;
    end
end
ang0=ang;%原始方向更新
  
  
  P=P+V*ang*T;
  if(~flagStop)
    Pt=Pt+300*[1 sin(omiga)]*T;
  end
  omiga=omiga+0.0001;
  
  d=(P(:,1)-Pt(1)).^2+(P(:,2)-Pt(2)).^2;
  d=d.^0.5;
  d_store(t)=mean(d);
  figure(1)
  circle;hold on
  plot(P(:,1),P(:,2),'.'); hold on
  plot(Pt(1),Pt(2),'r.'); hold on

  
  axis([0 20000 0 20000]);
  hold off

 
end
for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end




