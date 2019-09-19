clear
clc

n=100;

for i=1:n
    
      time1=clock;
       a=rand(i,i);
       p=minAssign(a);
%   p=all2all(a,i);
       time2=clock;
       time3=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    
    time(i)=time3;
end

i=1:n;
plot(i,time(i),'bo');
hold on
y=polyfit(i,time,4);
Y=polyval(y,i);
plot(i,Y,'r')