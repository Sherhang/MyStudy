%******中心点算法性能评估，随机生成位置，评估算法结果与完全法是否一致***%
clc;clear;
steps=100;
N=7;
flag1=0;
flag2=0;
for t=1:steps
   
    Fy=500*(rand(N,1)+0.5)*3;
    Fx=500.*[1 2 3 4 5 6 7  ]';
    Mx=Fx;My=Fy;
   Tx=50000+500*[4 5 7 9 10 160 18  ]';
   Ty=1000+500*[3 5 6 10 110 800  90 ]';
    singlePoint;
    Smaxval(t)=Smax;
    all2all;
    Amaxval(t)=gains(solution);
    if abs((Amaxval(t)-Dmaxval(t))./Amaxval(t))<=0.005
        flag1=flag1+1;
    end
     
    if Aplan==Splan
        flag2=flag2+1;
    end
    
   
end
result1=flag1/steps
result2=flag2/steps
figure(1)
plot(Amaxval,'r')
hold on
plot(Dmaxval,'b')
%% 
figure(2);
plot((Amaxval-Dmaxval)./Amaxval)    