%***�������ų�,������,�ٶȴ�С����,���ٶ�����
clear;clc;
flagStop=false;
%L0��L1,L2 ��F1�����޸�
V=800;T=0.02;steps=1000;omiga=0;
P=100*[0 0;0 1; 0 2; 0 5; 0 7; 0 8]+6000;
Pt=[6000 2000];
%P=100*rand(6,2)+1000;
P(:,1)=zeros(6,1);
theta=30+rand(6,1)*20;
theta=rand(6,1);
ang0=[cos(deg2rad(theta)),sin(deg2rad(theta))];%ԭʼ����
[m,~]=size(P);
for t=1:steps
  P_store(:,:,t)=P;
  for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
  end
 
  %AD����
  for i=1:m
    
      ang1(i,:)=F1(P(i,1),P(i,2),P);
  end
  
  %Ŀ�귽��
  ang3=F3(Pt(1),Pt(2),P);
  %Ȩ��
  w=weight(Pt(1),Pt(2),P);
  %һ�·���
  ang2=F2(P,ang3+ang0);
  %��������
  ang4=F4(Pt(1),Pt(2),P);
  %�ܷ���
  
  ang=ang1+(ang2+diag(w')*ang3)+10*ang4;
  %�ܷ���λ��
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
ang0=ang;%ԭʼ�������
  
  
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




