%%********中心点算法，所有点按照相对于中心点计算优先级*%%
clc;
clear;
steps=40;steps2=120;
Tpx(:,1)=[300 100 600]';Tvx=[1 1 4]';Mvx=Tvx;Tvx2=[2 -1 4 ]';
Tpy(:,1)=[10 60 300]';Tvy=[4 5 3]';Mvy=Tvy;Tvy2=[3 3 2]';
Mpx(:,1)=[0,100,200]';
Mpy(:,1)=[100 600 900]';
Mvx(:,1)=[0 0 0]';
Mvy(:,1)=[0 0 0]';
for t=1:10
    Tpx(:,t+1)=Tvx+Tpx(:,t);
    Tpy(:,t+1)=Tvy+Tpy(:,t);
    Ox(t)=1/6*sum(Mpx(:,t)+Tpx(:,t));
    Oy(t)=1/6*sum(Mpy(:,t)+Tpy(:,t));
    Tdis(:,t)=sqrt((Tpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Tpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    Mdis(:,t)=sqrt((Mpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Mpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    [temp,Tsort(:,t)]=sort(Tdis(:,t),'descend');
    [temp,Msort(:,t)]=sort(Mdis(:,t),'descend');
    Mvx(:,t+1)=-max(min( (Mpx(Msort(:,t),t)-Tpx(Tsort(:,t),t))./20,10),-10);%速度限制
    for j=1:3
      if abs(Mvx(j,t+1)-Mvx(j,t))>abs(Mvx(j,t))
        Mvx(j,t+1)=Mvx(j,t+1)+Mvx(j,t);
      end
    end
    Mvy(:,t+1)=-max(min((Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t))./20,10),-10);
     for j=1:3
      if abs(Mvy(j,t+1)-Mvy(j,t))>abs(Mvy(j,t))
        Mvy(j,t+1)=Mvy(j,t+1)+Mvy(j,t);
      end
    end
    Mpx(Msort(:,t),t+1)=Mpx(Msort(:,t),t)+Mvx(:,t+1);
    Mpy(Msort(:,t),t+1)=Mpy(Msort(:,t),t)+Mvy(:,t+1);
end
    
    for t=11:steps
    Tpx(:,t+1)=Tvx+Tpx(:,t);
    Tpy(:,t+1)=Tvy+Tpy(:,t);
    Ox(t)=1/6*sum(Mpx(:,t)+Tpx(:,t));
    Oy(t)=1/6*sum(Mpy(:,t)+Tpy(:,t));
    Tdis(:,t)=sqrt((Tpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Tpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    Mdis(:,t)=sqrt((Mpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Mpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    [temp,Tsort(:,t)]=sort(Tdis(:,t),'descend');
    [temp,Msort(:,t)]=sort(Mdis(:,t),'descend');
    Mvx(:,t+1)=-max(min( (Mpx(Msort(:,t),t)-Tpx(Tsort(:,t),t))./20,10),-10);%速度限制
    for j=1:3
    if abs(Mvx(j,t+1)-Mvx(j,t-5))>abs(Mvx(j,t-5))
        Mvx(j,t+1)=Mvx(j,t+1)+Mvx(j,t-5);
    end
    end
    Mvy(:,t+1)=-max(min((Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t))./20,10),-10);
    for j=1:3
      if abs(Mvy(j,t+1)-Mvy(j,t))>abs(Mvy(j,t))
        Mvy(j,t+1)=Mvy(j,t+1)+Mvy(j,t);
      end
    end
    Mpx(Msort(:,t),t+1)=Mpx(Msort(:,t),t)+Mvx(:,t+1);
    Mpy(Msort(:,t),t+1)=Mpy(Msort(:,t),t)+Mvy(:,t+1);
    end
%     ...
%     sqrt((Mpx(Msort(:,t),t)-Tpx(Tsort(:,t)).^2+(Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t)).^2)));
    

for t=steps+1:steps2
    Tpx(:,t+1)=Tvx2+Tpx(:,t);
    Tpy(:,t+1)=Tvy2+Tpy(:,t);
    Ox(t)=1/6*sum(Mpx(:,t)+Tpx(:,t));
    Oy(t)=1/6*sum(Mpy(:,t)+Tpy(:,t));
    Tdis(:,t)=sqrt((Tpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Tpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    Mdis(:,t)=sqrt((Mpx(:,t)- [Ox(t); Ox(t); Ox(t)]).^2+(Mpy(:,t)- [Oy(t); Oy(t); Oy(t)]).^2);
    [temp,Tsort(:,t)]=sort(Tdis(:,t),'descend');
    [temp,Msort(:,t)]=sort(Mdis(:,t),'descend');
    Mvx(:,t)=-max(min( (Mpx(Msort(:,t),t)-Tpx(Tsort(:,t),t))./10,10),-10);%速度限制
    Mvy(:,t)=-max(min((Mpy(Msort(:,t),t)-Tpy(Tsort(:,t),t))./10,10),-10);
    Mpx(Msort(:,t),t+1)=Mpx(Msort(:,t),t)+Mvx(:,t);
    Mpy(Msort(:,t),t+1)=Mpy(Msort(:,t),t)+Mvy(:,t);
end
%% 

%% 

figure(1);
pause(2);
for i=1:steps2
     plot(Tpx(:,i),Tpy(:,i),'or');
     axis([0 1500 0 1500]);
     hold on;
     plot(Mpx(:,i),Mpy(:,i),'*b');
     axis([0 1500 0 1500]);
     text(Tpx(1,i),Tpy(1,i),'目标1');
     text(Tpx(2,i),Tpy(2,i),'目标2');
     text(Tpx(3,i),Tpy(3,i),'目标3');
     text(Mpx(1,i),Mpy(1,i),'导弹1');
     text(Mpx(2,i),Mpy(2,i),'导弹2');
     text(Mpx(3,i),Mpy(3,i),'导弹3');
     hold off;
     pause(0.05);
     
         
end
% text(Tpx(1,1),Tpy(1,1),'目标1');
% text(Tpx(2,1),Tpy(2,1),'目标2');
% text(Tpx(3,1),Tpy(3,1),'目标3');
% text(Mpx(1,1),Mpy(1,1),'导弹1');
% text(Mpx(2,1),Mpy(2,1),'导弹2');
% text(Mpx(3,1),Mpy(3,1),'导弹3');
% for t=2:steps2-1
%    for j=1:3
%        if ((Msort(j,t)-Tsort(j,t))~= (Msort(j,t+1)-Tsort(j,t-1)))
%          text(Mpx(:,t),Mpy(:,t),'change');
%          text(Tpx(:,t),Tpy(:,t),'change');
%        end
%    end
% end


    