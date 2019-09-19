%***算法运行时间测试

clear
clc

n=10;

for i=1:n
    for j=1:20
      time1=clock;
       a=rand(i,i);
       p=minAssign(a+0.000001*rand(i,i));
%   p=all2all(a,i);
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end
    time(i)=mean(time3);
end

for i=1:n
    for j=1:2
      time11=clock;
       a1=rand(i,i);
       p1=minzp(a1);
%   p=all2all(a,i);
       time21=clock;
       time31(j)=60*time21(5)-60*time11(5)+time21(6)-time11(6);
    end
    timeminzp(i)=mean(time31);
end

figure(1)
set(gcf,'color','w');
plot(timeminzp,'r');
hold on
plot(time,'b');
% x=1:200                                                                                      
% y=polyfit(x,time,5);
% Y=polyval(y,x);
% plot(x,Y,'r');
 xlabel('问题规模/N');
 ylabel('执行时间/s');
 legend('分支定界法','量子规划');