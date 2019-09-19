clear;
clc;
PH=0.2;
PL=1;
P0=0.9;%对方是高成本阻挠的概率，实际值
s0=P0*PH+(1-P0)*PL;
P(1)=0.7;%初始值，是高成本阻挠的概率
steps=100;
s(1)=P(1)*PH+(1-P(1))*PL;%阻挠概率
a=rand(steps,1);
for i=2:steps
    if(a(i)<=s0)
        PAB(i)=0.2*P(i-1)/s(i-1);
        P(i)=PAB(i);
        s(i)=P(i)*PH+(1-P(i))*PL;
    end
    if(a(i)>s0)
        PAC(i)=0.8*(1-P(i-1))/(1-s(i-1));
        P(i)=1-PAC(i);
        s(i)=P(i)*PH+(1-P(i))*PL;
    end
end
t=1:steps;
plot(t,P,'*');

        
        
    


