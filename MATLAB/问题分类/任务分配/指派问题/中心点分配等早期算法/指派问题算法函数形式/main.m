clc;clear;
steps1=1000;steps2=100;
flag=0;
flag1=0;
N=7;
fx(:,1)=200.*[1 2 3 4 5 6 7 ]';
fy(:,1)=-200*[1 2 -1 1 4 -1  6]';
mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
tx(:,1)=10000+50*[4 5 7 -6 -4 -6  5 ]';
ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 ]';
for t=1:steps1
   fx(:,t+1)=fx(:,t)+20*[1 1 1  2 3 4 4 ]';
    fy(:,t+1)=fy(:,t)+20*[-3 -2  -1 1 2 3 4]';
%     fx(:,t+1)=30000*rand(1,N)';
%     fy(:,t+1)=400000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
   tx(:,t+1)=tx(:,t)+70*[4 5 6 5 6 4  4]';
   ty(:,t+1)=ty(:,t)+80*[6 5 4 0 -1 -2  3]';
%     tx(:,t+1)=50000+50000*rand(1,N)';
%     ty(:,t+1)=80000*rand(1,N)';
end
for t=1:steps2;
    %************* ÍþÐ²¾ØÕó
    Fx=fx(:,t);
    Fy=fy(:,t);
    Mx=mx(:,t);
    My=my(:,t);
    Tx=tx(:,t);
    Ty=ty(:,t);
    pro=probility(Fx,Fy,Tx,Ty,N);
    threat=pro;
    Val=pro.*threat;
    
    [Aplan,gains,c]=all2all(Val,N);
    simpleVal(t)=mean(gains);
    Amaxval(t)=sum(sum(Val.*codeVal2codeBool(Aplan,N)));
    
    Gplan=gradualMax( Val,N);
    Gmaxval(t)=sum(sum(Val.*codeVal2codeBool(Gplan,N)));
    Splan=[2 4 5 7 1 3 6];
    
    for i=1:20
             Splan=search( Val,Splan,N );
    end
    
    Smaxval(t)=sum(sum(Val.*codeVal2codeBool(Splan,N)));
    
    [ plan,~ ]=minzp(max(max(Val))-Val);
    Lplan=codeBool2codeVal(plan,N);
    Lmaxval(t)=sum(sum(Val.*plan));
    
end
figure(1);
plot((Amaxval-Gmaxval)./Amaxval,'b')
hold on
plot((Amaxval-Lmaxval)./Amaxval,'m')
hold on
plot((Amaxval-Smaxval)./Amaxval,'k')
hold on
plot((Amaxval-simpleVal)./Amaxval,'g')
hold on
figure(2)
plot(gains,'o')

    