%********逐次最优法***********%
%*************补充说明，超过10阶，计算机已经无法产生全排列，这种情况下解空间已经不可知，用粒子群等算法搜索这种解空间没有意义*****%
clc;clear;
steps1=1000;steps2=1;
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
fy(:,1)=-200*[1 2 -1 1 4 -1  6]';
mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
tx(:,1)=100000+300*[4 5 7 -6 -4 -6  5 ]';
ty(:,1)=100000+500*[-3 -5 6 -3 -4 8  9 ]';
a=1:N;
c=perms(a);%全排列
for t=1:steps1
%    fx(:,t+1)=fx(:,t)+200*[1 1 1  2 3 4 4 ]';
%     fy(:,t+1)=fy(:,t)+250*[-3 -2  -1 1 2 3 4]';
    fx(:,t+1)=30000*rand(1,N)';
    fy(:,t+1)=400000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
%    tx(:,t+1)=tx(:,t)+800*[4 5 6 5 6 4  4]';
%    ty(:,t+1)=ty(:,t)+800*[6 5 4 0 -1 -2  3]';
    tx(:,t+1)=50000+50000*rand(1,N)';
    ty(:,t+1)=80000*rand(1,N)';
end
%% 算法
for t=1:steps2;
    %************* 威胁矩阵
    Fx=fx(:,t);
    Fy=fy(:,t);
    Mx=mx(:,t);
    My=my(:,t);
    Tx=tx(:,t);
    Ty=ty(:,t);
    for i=1:N
        for j=1:N
            pro(i,j)=100000./sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
        end
    end
    threat=pro;%************
    threat=mapminmax(threat,0.1,1)+0.1*ones(N);
    threat(:,1)=threat(:,1)+0.1*[1 1 1  1  1 1 1]';
    pro=mapminmax(pro',0.1,1)'+0.1*ones(N);
    all2all;%全体解
    gradualmax;% 逐次最优
    doublePoint;% 双中心点
    singlePoint;
        simpleval(t)=mean(gains);%全体均值
    Aminval(t)=min(gains);
    search1;%搜索
    if Amaxval(t)==Smaxval(t)
        flag=flag+1;
    end
    C=max(max(pro.*threat))-pro.*threat;
    [ y,~] = minzp(C);
    Zplan=codeBool2codeVal(y,N);
    Zmaxval(t)=sum(sum(pro.*threat.*y));
    if Amaxval(t)==Zmaxval(t)
        flag1=flag1+1;
    end

end

percent=flag/steps2
per1=flag1/steps2
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
hh1=line([0,factorial(N)],[Amaxval(steps2),Amaxval(steps2)]);
set(hh1,'color','r');
hold on
plot(gp,gains(gp),'g*');text(gp,gains(gp),'逐次最优解');
hold on
hh2=line([0,factorial(N)],[Gmaxval(steps2),Gmaxval(steps2)]);
set(hh2,'color','g');
hold on
plot(dp,gains(dp),'k*');text(dp,gains(dp),'双心最优解');
hold on
hh3=line([0,factorial(N)],[Dmaxval(steps2),Dmaxval(steps2)]);
set(hh3,'color','k');
hold on
plot(s1,gains(s1),'m*');text(s1,gains(s1),'搜索最优解');
hold on
hh4=line([0,factorial(N)],[Smaxval(steps2),Smaxval(steps2)]);
set(hh4,'color','b');

hold off


figure(2);
plot((Amaxval-Gmaxval)./(Amaxval-Aminval),'b')
hold on
plot((Amaxval-Dmaxval)./(Amaxval-Aminval),'m')
hold on
plot((Amaxval-Singmaxval)./(Amaxval-Aminval),'g')
hold on

plot((Amaxval-simpleval)./(Amaxval-Aminval),'r')  
hold on
plot((Amaxval-Smaxval)./(Amaxval-Aminval),'k')  
hold on
plot((Amaxval-Zmaxval)./(Amaxval-Aminval),'b')  



figure(4)

     plot(tx,ty,'r*');
     hold on;
     plot(fx,fy,'bo');
%      axis(100*[-100 1500 -200 2000]);
     hold on;   

     text(tx(1,1)-100,ty(1,1)+20,'目标1');
     text(tx(2,1)-100,ty(2,1)+20,'目标2');
     text(tx(3,1)-100,ty(3,1)+20,'目标3');
     text(tx(4,1)-100,ty(4,1)+20,'目标4');
     text(tx(5,1)-100,ty(5,1)+20,'目标5');
     text(tx(6,1)-100,ty(6,1)+20,'目标6');
     text(tx(7,1)-100,ty(7,1)+20,'目标7');
    
     text(mx(1,1)-50,my(1,1),'导弹1');
     text(mx(2,1)-50,my(2,1),'导弹2');
     text(mx(3,1)-50,my(3,1),'导弹3');
     text(mx(4,1)-50,my(4,1),'导弹4');
     text(mx(5,1)-50,my(5,1),'导弹5');
     text(mx(6,1)-50,my(6,1),'导弹6');
     text(mx(7,1)-50,my(7,1),'导弹7');