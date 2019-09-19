%AR��άģ��
clear;clc;
%��ʼ������
NM=4;%��������
NT=2;%Ŀ������
LOfDetect=100000;%̽�����
AOfDetect=deg2rad(15);%̽��Ƕ�
LOfConnect=300000;%ͨ�ž���
Lmin=1000;%����ײ��ֵ
dt=0.02;%����ʱ��
T=0;
Vm=800;
Vt=300;
%��ʼλ�úͽǶ�
Pm=rand(NM,2)*10000;
Pt=rand(NT,2)*10000;
Am=rand(NM,2);
At=rand(NT,2);
while(T<10)
%����ͨ�ž������
for i=1:NM
    for j=1:NM
        D1(i,j)=(Pm(i,1)-Pm(j,1))^2+(Pm(i,2)-Pm(j,2))^2;
        D1(i,j)=sqrt(D1(i,j));
    end
end
%����̽��������
for i=1:NM
    for j=1:NT
        D2(i,j)=(Pm(i,1)-Pt(j,1))^2+(Pm(i,2)-Pt(j,2))^2;
        D2(i,j)=sqrt(D2(i,j));
    end
end
%��Ⱥ�˶�
sortNear=D1<LOfConnect;%�ҵ�ͨ������
sortNear2=D1<10;
for i=1:NM
    for j=1:NM
        if (i~=j)&&sortNear(i,j)==1;
            Am(i,:)=Am(i,:)+(Pm(j,:)-Pm(i,:))*FAR(D1(i,j),Lmin);
        end
        
    end
    
    Am(i,1)=mean(Am(sortNear2(i,:)==1));
    Am(i,2)=mean(Am(sortNear2(i,:)==1));
    Pm(i,:)=Pm(i,:)+Vm*Am(i,:)/norm(Am(i,:))*dt;
end

T=T+dt;
figure(1)
%axis([0 1 0 1 ]*10000000)
hold on
plot(Pm(1,1),Pm(1,2),'r.')
plot(Pm(2,1),Pm(2,2),'b.')
plot(Pm(3,1),Pm(3,2),'g.')
plot(Pm(4,1),Pm(4,2),'y.')
end




    
