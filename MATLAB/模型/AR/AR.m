%AR��άģ��
clear;clc;
%��ʼ������
NM=8;%��������
NT=2;%Ŀ������
LOfDetect=1000;%̽�����
AOfDetect=deg2rad(15);%̽��Ƕ�
LOfConnect=3000;%ͨ�ž���
Lmin=100;%����ײ��ֵ
dt=0.02;%����ʱ��
T=0;
Vm=800;
Vt=300;
%��ʼλ�úͽǶ�
Pm=rand(NM,3)*10000;
Pt=rand(NT,3)*10000;
Am=rand(NM,3);
At=rand(NT,3);
while(T<10)
%����ͨ�ž������
for i=1:NM
    for j=1:NM
        D1(i,j)=(Pm(i,1)-Pm(j,1))^2+(Pm(i,2)-Pm(j,2))^2+(Pm(i,3)-Pm(j,3))^2;
        D1(i,j)=sqrt(D1(i,j));
    end
end
%����̽��������
for i=1:NM
    for j=1:NT
        D2(i,j)=(Pm(i,1)-Pt(j,1))^2+(Pm(i,2)-Pt(j,2))^2+(Pm(i,3)-Pt(j,3))^2;
        D2(i,j)=sqrt(D2(i,j));
    end
end
%��Ⱥ�˶�
sortNear=D1<LOfConnect;%�ҵ�ͨ������
for i=1:NM
    for j=1:NM
        if (i~=j)&&sortNear(i,j)==1;
            Am(i,:)=Am(i,:)-(Pm(j,:)-Pm(i,:))*FAR(D1(i,j),Lmin);
        end
        Pm(i,:)=Pm(i,:)+Vm*Am(i,:);
    end
end

T=T+dt;
figure(1)
axis([0 1 0 1 0 1]*10000000)
hold on
plot3(Pm(:,1),Pm(:,2),Pm(:,3),'.')

end




    
