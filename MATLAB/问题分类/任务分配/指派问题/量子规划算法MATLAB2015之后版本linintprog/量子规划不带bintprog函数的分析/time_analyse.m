%*******算法执行时间
clear
clc
n=500;
%量子规划第一版，固定坍缩方案
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign1(a);
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time01(i)=mean(time3);%基本量子规划
end

%模拟坍缩
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign(a);%默认测量次数n
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time02(i)=mean(time3);%
end

%干扰量子规划
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign1(a+0.000001*rand(i,i));
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time03(i)=mean(time3);%
end

%4
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign(a+0.000001*rand(i,i));
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time04(i)=mean(time3);%
end

save 时间数据随机矩阵.mat time01 time02 time03 time04
figure(1)
set(gcf,'color','w');
plot(time01,'r');
hold on
plot(time02,'b');
hold on
plot(time03,'g');
hold on
plot(time04,'y');
xlabel('问题规模/N');
ylabel('执行时间/s');
legend('基本量子规划','模拟坍缩量子规划','人为干扰量子规划','人为干扰模拟坍缩量子规划');


    
   