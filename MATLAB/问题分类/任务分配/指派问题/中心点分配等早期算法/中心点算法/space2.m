%%********中心点算法，j加入MCDM
clc;
clear;
steps=10;steps2=100;
Tpx(:,1)=50000+100*[100 120 140 160 180 200 220 240]';Tvx=287.*[1 1 1 1 1 1 1 1 ]';Mvx=Tvx;Tvx2=340*[1.5 1.7 2.2 2.7 2.1 2.4 1.8 2.1 ]';
Tpy(:,1)=50000+100*[300 330 360 390 420 450 480 510]';Tvy=-287.*[1 1 1 1 1 1 1 1 ]';Mvy=Tvy;Tvy2=340*[-2.9 -2.4 -2.1 -1.7 0 0.8 0.7 1.6]';
Mpx(:,1)=100*[150,100,200 10 60 50 120 180]';
Mpy(:,1)=30000+100*[900 750 500 400 340 200 150 100]';
Mvx(:,1)=[0 0 0 0 0 0 0 0]';
Mvy(:,1)=[0 0 0 0 0 0 0 0]';
%% 第一阶段
for t=1:steps
    Tpx(:,t+1)=Tvx+Tpx(:,t);
    Tpy(:,t+1)=Tvy+Tpy(:,t);
  
    Ox(t)=1/16*sum(Mpx(:,t)+Tpx(:,t));
    Oy(t)=1/16*sum(Mpy(:,t)+Tpy(:,t));
    Tdis(:,t)=sqrt((Tpx(:,t)- [Ox(t); Ox(t);Ox(t);Ox(t);Ox(t);Ox(t);Ox(t); Ox(t)]).^2+(Tpy(:,t)- [Oy(t); Oy(t);Oy(t);Oy(t);Oy(t);Oy(t);Oy(t); Oy(t)]).^2);
    Mdis(:,t)=sqrt((Mpx(:,t)- [Ox(t); Ox(t); Ox(t);Ox(t);Ox(t);Ox(t);Ox(t);Ox(t)]).^2+(Mpy(:,t)- [Oy(t); Oy(t); Oy(t);Oy(t);Oy(t);Oy(t);Oy(t);Oy(t)]).^2);
    class=[1 1 1 1 0.8 0.8 0.8 0.6]';
    threat(:,t)=MCDM( Tdis(:,t), sqrt(Tvx.^2+Tvy.^2), Tpx(:,t),Tpy(:,t),Ox(:,t),Oy(:,t),Tvx,Tvy, class );
    
    
    [temp,Tsort(:,t)]=sort(threat(:,t),'descend');
    [temp,Msort(:,t)]=sort(Mdis(:,t),'descend');
    Mvx(:,t+1)=-max(min( (Mpx(Msort(:,t),t)-Tpx(Tsort(:,t),t))./20,340*5),-340*5);%速度限制
    for j=1:6
      if abs(Mvx(j,t+1)-Mvx(j,t))>abs(Mvx(j,t))
        Mvx(j,t+1)=Mvx(j,t+1)+1.5*Mvx(j,t);
      end
    end
    Mvy(:,t+1)=-max(min((Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t))./20,1360),-1360);
     for j=1:6
      if abs(Mvy(j,t+1)-Mvy(j,t))>abs(Mvy(j,t))
        Mvy(j,t+1)=Mvy(j,t+1)+Mvy(j,t);
      end
    end
    Mpx(Msort(:,t),t+1)=Mpx(Msort(:,t),t)+Mvx(:,t+1);
    Mpy(Msort(:,t),t+1)=Mpy(Msort(:,t),t)+Mvy(:,t+1);
end
    
    
    
%% 第二阶段 目标改变轨迹
for t=steps+1:steps2
    Tpx(:,t+1)=Tvx2+Tpx(:,t);
    Tpy(:,t+1)=Tvy2+Tpy(:,t);
    
    
       Ox(t)=1/16*sum(Mpx(:,t)+Tpx(:,t));
       Oy(t)=1/16*sum(Mpy(:,t)+Tpy(:,t));
       Tdis(:,t)=sqrt((Tpx(:,t)- [Ox(t); Ox(t);Ox(t);Ox(t);Ox(t);Ox(t);Ox(t); Ox(t)]).^2+(Tpy(:,t)- [Oy(t); Oy(t);Oy(t);Oy(t);Oy(t);Oy(t);Oy(t); Oy(t)]).^2);
       Mdis(:,t)=sqrt((Mpx(:,t)- [Ox(t); Ox(t); Ox(t);Ox(t);Ox(t);Ox(t);Ox(t);Ox(t)]).^2+(Mpy(:,t)- [Oy(t); Oy(t); Oy(t);Oy(t);Oy(t);Oy(t);Oy(t);Oy(t)]).^2);
    
    [temp,Tsort(:,t)]=sort(Tdis(:,t),'descend');
    [temp,Msort(:,t)]=sort(Mdis(:,t),'descend');
    if t>25
         Tsort(:,t)=Tsort(:,t-1);
         Msort(:,t)=Msort(:,t-1);
    end
     Mvx(:,t+1)=-max(min( (Mpx(Msort(:,t),t)-Tpx(Tsort(:,t),t))./5,1360),-1360);%速度限制
    for j=1:6
      if abs(Mvx(j,t+1)-Mvx(j,t))>abs(Mvx(j,t))
        Mvx(j,t+1)=Mvx(j,t+1)+1.5*Mvx(j,t);
      end
    end
    Mvy(:,t+1)=-max(min((Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t))./5,1360),-1360);
     for j=1:6
      if abs(Mvy(j,t+1)-Mvy(j,t))>abs(Mvy(j,t))
        Mvy(j,t+1)=Mvy(j,t+1)+Mvy(j,t);
      end
    end
    Mpx(Msort(:,t),t+1)=Mpx(Msort(:,t),t)+Mvx(:,t);
    Mpy(Msort(:,t),t+1)=Mpy(Msort(:,t),t)+Mvy(:,t);
end


%% 追踪图

figure(1);
pause(2);
for i=1:steps2-1
     plot(Tpx(:,i),Tpy(:,i),'or');
     hold on;
     plot(Mpx(:,i),Mpy(:,i),'*b');
     axis(100*[-100 1600 -200 2000]);
     text(Tpx(1,i)-10,Tpy(1,i)-10,'目标1');
     text(Tpx(2,i),Tpy(2,i),'目标2');
     text(Tpx(3,i),Tpy(3,i),'目标3');
     text(Tpx(4,i),Tpy(4,i),'目标4');
     text(Tpx(5,i),Tpy(5,i),'目标5');
     text(Tpx(6,i),Tpy(6,i),'目标6');
     text(Tpx(7,i),Tpy(7,i),'目标7');
     text(Tpx(8,i),Tpy(8,i),'目标8');
     text(Mpx(1,i),Mpy(1,i),'导弹1');
     text(Mpx(2,i),Mpy(2,i),'导弹2');
     text(Mpx(3,i),Mpy(3,i),'导弹3');
     text(Mpx(4,i),Mpy(4,i),'导弹4');
     text(Mpx(5,i),Mpy(5,i),'导弹5');
     text(Mpx(6,i),Mpy(6,i),'导弹6');
     text(Mpx(7,i),Mpy(7,i),'导弹7');
     text(Mpx(8,i),Mpy(8,i),'导弹8');
     hold off;
     pause(0.04);    
%      for j=1:6
%        if (Msort(j,i)~= Msort(j,i+1)||Tsort(j,i)~= Tsort(j,i+1))
%          text(Mpx(j,i),Mpy(j,i)+3000,'C');
%          hold on;
% %          text(Tpx(j,i),Tpy(j,i),'change');
%        end
%      end
end
hold on;
plot(Ox,Oy,'g');
%% 轨迹图

figure(2);
pause(2);
for i=1:steps2-1
     plot(Tpx(:,i),Tpy(:,i),'or');
     hold on;
     plot(Mpx(:,i),Mpy(:,i),'*b');
     axis(100*[-100 1600 -200 2000]);
     
     hold on;
     pause(0.01);    
     for j=1:6
        
       if (Msort(j,i)~= Msort(j,i+1)||Tsort(j,i)~= Tsort(j,i+1))
         text(Mpx(j,i),Mpy(j,i)+3000,'C');
%          text(Tpx(j,i),Tpy(j,i)+20,'change');
       end
     end
end
     text(Tpx(1,1)-100,Tpy(1,1)+20,'目标1');
     text(Tpx(2,1)-100,Tpy(2,1)+20,'目标2');
     text(Tpx(3,1)-100,Tpy(3,1)+20,'目标3');
     text(Tpx(4,1)-100,Tpy(4,1)+20,'目标4');
     text(Tpx(5,1)-100,Tpy(5,1)+20,'目标5');
     text(Tpx(6,1)-100,Tpy(6,1)+20,'目标6');
     text(Tpx(7,1)-100,Tpy(7,1)+20,'目标7');
     text(Tpx(8,1),Tpy(8,1),'目标8');
     text(Mpx(1,1)-5000,Mpy(1,1),'导弹1');
     text(Mpx(2,1)-5000,Mpy(2,1),'导弹2');
     text(Mpx(3,1)-5000,Mpy(3,1),'导弹3');
     text(Mpx(4,1)-5000,Mpy(4,1),'导弹4');
     text(Mpx(5,1)-5000,Mpy(5,1),'导弹5');
     text(Mpx(6,1)-5000,Mpy(6,1),'导弹6');
     text(Mpx(7,1)-5000,Mpy(7,1),'导弹7');
     text(Mpx(8,1)-5000,Mpy(8,1),'导弹8');
     k=90;
     text(Tpx(1,k)-10,Tpy(1,k)-10,'目标1');
     text(Tpx(2,k),Tpy(2,k),'目标2');
     text(Tpx(3,k),Tpy(3,k),'目标3');
     text(Tpx(4,k),Tpy(4,k),'目标4');
     text(Tpx(5,k),Tpy(5,k),'目标5');
     text(Tpx(6,k),Tpy(6,k),'目标6');
     text(Tpx(7,k),Tpy(7,k),'目标7');
     text(Tpx(8,k),Tpy(8,k),'目标8');
     text(Mpx(1,k),Mpy(1,k),'导弹1');
     text(Mpx(2,k),Mpy(2,k),'导弹2');
     text(Mpx(3,k),Mpy(3,k),'导弹3');
     text(Mpx(4,k),Mpy(4,k),'导弹4');
     text(Mpx(5,k),Mpy(5,k),'导弹5');
     text(Mpx(6,k),Mpy(6,k),'导弹6');
     text(Mpx(7,k),Mpy(7,k),'导弹7');
     text(Mpx(8,k),Mpy(8,k),'导弹8');



    %%***********半中心算法*************%%

