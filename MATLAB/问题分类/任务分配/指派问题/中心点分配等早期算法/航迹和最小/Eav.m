%********逐次最优法***********%
%*************补充说明，超过10阶，计算机已经无法产生全排列，这种情况下解空间已经不可知，用粒子群等算法搜索这种解空间没有意义*****%
clc;clear;
steps1=500;steps2=100 ;
flag=0;
flag1=0;
N=7;
%% 生成位置
% fx(:,1)=800.*rand(1,N)';
% fy(:,1)=-500*rand(1,N)';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=500*rand(1,N)';
% ty(:,1)=500*rand(1,N)';
fx(:,1)=200.*[1 2 3 4 5 6 7 ]';
fy(:,1)=-200*[1 2 -1 0 1 -1 2 ]';
fz(:,1)=300*[1 3 1 5 4 2 6 ]';
mx(:,1)=fx(:,1);my(:,1)=fy(:,1);mz(:,1)=fz(:,1);
tx(:,1)=500000+300*[4 5 7 -6 -4 -6  5 ]';
ty(:,1)=500000+500*[-3 -5 6 -3 -4  6 9 ]';
tz(:,1)=500000+500*[3 4 6 1 5 3 2 ]';
a=1:N;
c=perms(a);%全排列
for t=1:steps1
   fx(:,t+1)=fx(:,t)+100*[-1 1 1 1 2 2 2  ]';
   fy(:,t+1)=fy(:,t)+100*[-1 -1 -1 2 1 2 1 ]';
   fz(:,t+1)=fz(:,t)+100*[-1 -1 -1 1 1 2 1 ]';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);mz(:,t)=fz(:,t);
   tx(:,t+1)=tx(:,t)+500*[2 -1 2 2 1 2 -1]';
   ty(:,t+1)=ty(:,t)+500*[1 -1 2 2 -1 2 -1]';
   tz(:,t+1)=tz(:,t)+500*[-1 2 3 3 2 3 3 ]';

%     fx(:,t+1)=30000*rand(1,N)';
%     fy(:,t+1)=400000*rand(1,N)';
%     fz(:,t+1)=600000*rand(1,N)';
%     mx(:,t)=fx(:,t);my(:,t)=fy(:,t);mz(:,t)=fz(:,t);
%     tx(:,t+1)=50000+50000*rand(1,N)';
%     ty(:,t+1)=80000*rand(1,N)';
%     tz(:,t+1)=80000*rand(1,N)';
end
%% 算法
for t=1:steps2;
    
    Fx=fx(:,t);
    Fy=fy(:,t);
    Fz=fz(:,t);
    Mx=mx(:,t);
    My=my(:,t);
    Mz=mz(:,t);
    Tx=tx(:,t);
    Ty=ty(:,t);
    Tz=tz(:,t);
    for i=1:N
        for j=1:N
            dis(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2+(Fz(i)-Tz(j))^2)./10000;
        end
    end
    
    all2all;%全体解
    gradualmax;% 逐次最优
    simpleval(t)=mean(gains);%全体均值
    
    search1;%搜索
    if Aminval(t)==Sminval(t)
        flag=flag+1;
    end

 
end

percent=flag/steps2

%% plot
figure(1)
for k=1:factorial(N);
plot(k,gains(k),'o');
%pause(0.001);
hold on
end
hold on
plot(solution,gains(solution),'r*'); text(solution,gains(solution),'最优解');
hold on
hh1=line([0,factorial(N)],[gains(solution),gains(solution)]);
set(hh1,'color','r');
hold on
plot(gp,gains(gp),'g*');text(gp,gains(gp),'逐次最优解');
hold on
hh2=line([0,factorial(N)],[gains(gp),gains(gp)]);
set(hh2,'color','g');
hold on
plot(s1,gains(s1),'m*');text(s1,gains(s1),'搜索最优解');
hold on
hh4=line([0,factorial(N)],[gains(s1),gains(s1)]);
set(hh4,'color','b');

hold off


% figure(2);
% plot((Amaxval-Gmaxval)./(Amaxval),'b')
% hold on
% plot((Amaxval-simpleval)./(Amaxval),'r')  
% hold on
% plot((Amaxval-Smaxval)./(Amaxval),'k')  

figure(2);
plot((Aminval-Gminval)./(Aminval),'b')
hold on
plot((Aminval-simpleval)./(Aminval),'r')  
hold on
plot((Aminval-Sminval)./(Aminval),'k')  



figure(4)

     plot3(tx,ty,tz,'r*');
     hold on;
     plot3(fx,fy,fz,'bo');
%      axis(100*[-100 1500 -200 2000]);
     hold on;   

     text(tx(1,1)-100,ty(1,1)+20,tz(1,1),'目标1');
     text(tx(2,1)-100,ty(2,1)+20,tz(2,1),'目标2');
     text(tx(3,1)-100,ty(3,1)+20,tz(3,1),'目标3');
     text(tx(4,1)-100,ty(4,1)+20,tz(4,1),'目标4');
     text(tx(5,1)-100,ty(5,1)+20,tz(5,1),'目标5');
     text(tx(6,1)-100,ty(6,1)+20,tz(6,1),'目标6');
     text(tx(7,1)-100,ty(7,1)+20,tz(7,1),'目标7');
    
     text(mx(1,1)-50,my(1,1),my(1,1),'导弹1');
     text(mx(2,1)-50,my(2,1),my(2,1),'导弹2');
     text(mx(3,1)-50,my(3,1),my(3,1),'导弹3');
     text(mx(4,1)-50,my(4,1),my(4,1),'导弹4');
     text(mx(5,1)-50,my(5,1),my(5,1),'导弹5');
     text(mx(6,1)-50,my(6,1),my(6,1),'导弹6');
     text(mx(7,1)-50,my(7,1),my(7,1),'导弹7');