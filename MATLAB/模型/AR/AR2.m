%AR三维模型
clear;clc;
%初始化参数
NM=4;%导弹数量
NT=2;%目标数量
LOfDetect=100000;%探测距离
AOfDetect=deg2rad(15);%探测角度
LOfConnect=300000;%通信距离
Lmin=1000;%防碰撞阈值
dt=0.02;%采样时间
T=0;
Vm=800;
Vt=300;
%初始位置和角度
Pm=rand(NM,2)*10000;
Pt=rand(NT,2)*10000;
Am=rand(NM,2);
At=rand(NT,2);
while(T<10)
%计算通信距离矩阵
for i=1:NM
    for j=1:NM
        D1(i,j)=(Pm(i,1)-Pm(j,1))^2+(Pm(i,2)-Pm(j,2))^2;
        D1(i,j)=sqrt(D1(i,j));
    end
end
%计算探测距离矩阵
for i=1:NM
    for j=1:NT
        D2(i,j)=(Pm(i,1)-Pt(j,1))^2+(Pm(i,2)-Pt(j,2))^2;
        D2(i,j)=sqrt(D2(i,j));
    end
end
%集群运动
sortNear=D1<LOfConnect;%找到通信邻域
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




    
