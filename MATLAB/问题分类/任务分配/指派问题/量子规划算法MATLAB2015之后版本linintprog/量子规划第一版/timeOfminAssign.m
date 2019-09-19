clear
clc

n=100;

for i=1:n
    for j=1:10
      time1=clock;
       a=rand(i,i);
       p=minAssign(a);
%   p=all2all(a,i);
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end
    time(i)=mean(time3);
end

i=1:n;
plot(i.^2,time(i))