clc;clear;
N=9;
steps1=1000;steps2=10;steps3=N;numOfPop=N;
flag=0;
flag1=0;

fx(:,1)=200.*[1 2 3 4 5 6 7 1 1]';
fy(:,1)=-200*[1 2 -1 1 4 -1  6 1 1]';
mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
tx(:,1)=10000+50*[4 5 7 -6 -4 -6 5 1 1]';
ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 1 2 ]';
for t=1:steps1
   fx(:,t+1)=fx(:,t)+20*[1 1 1  2 3 4 4  1 2]';
    fy(:,t+1)=fy(:,t)+20*[-3 -2  -1 1 2 3 1 2 4]';
%     fx(:,t+1)=30000*rand(1,N)';
%     fy(:,t+1)=400000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
   tx(:,t+1)=tx(:,t)+70*[4 5 6 5 6 4  4 1 2]';
   ty(:,t+1)=ty(:,t)+80*[6 5 4 0 -1 -2 1 2 3]';
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
%     figure(1);
    for i=1:numOfPop
        Splan=randperm(N);
        for j=1:steps3
             Splan=search( Val,Splan,N );
%              plot(gains,'o');
%              hold on
%               [~,s,~]=intersect(c,Splan,'rows')  ; 
%              plot(s,gains(s),'r*')
%              hold off
%               pause(0.3);
             
        end
%          plot(gains,'o');
%              hold on
%              [~,s,~]=intersect(c,Splan,'rows')  ; 
%              plot(s,gains(s),'r*')
%              hold off
%               pause(0.3);
        
    end
 
    Smaxval(t)=sum(sum(Val.*codeVal2codeBool(Splan,N)));
        [ plan,~ ]=minzp(max(max(Val))-Val);
    Lplan=codeBool2codeVal(plan,N);
    Lmaxval(t)=sum(sum(Val.*plan));
    
     L2plan=minAssign(max(max(Val))-Val);
   
    L2maxval(t)=sum(sum(Val.*codeVal2codeBool(L2plan,N)));
    
end

figure(2);
% plot((Amaxval-Gmaxval)./Amaxval,'b')
% hold on
plot((Amaxval-Lmaxval)./Amaxval,'m')
hold on
plot((Amaxval-L2maxval)./Amaxval,'y')
hold on
plot((Amaxval-Smaxval)./Amaxval,'k')
hold on
plot((Amaxval-simpleVal)./Amaxval,'g')
hold on


    