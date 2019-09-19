 clear
 clc
 n=50;
flag1=0;
flag(1)=0;
 for step=2:n
      flag(step)=0;
     time1=clock;
    Splan=randperm(step);
    a=rand(step,step);
     while 1
         choosePlan=search( a,Splan,step );
         if Splan==choosePlan
             flag1=flag1+1;
             break;
         end
             Splan=choosePlan;
             flag(step)=flag(step)+1;
             
     end
     time2=clock;
     time(step)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
 end
 figure(1)
i=2:n;
plot(i,time(i))
 xlabel('问题规模N')
 ylabel('搜索时间/s')
figure(2)
 plot(flag)
 xlabel('问题规模')
 ylabel('搜索步长')