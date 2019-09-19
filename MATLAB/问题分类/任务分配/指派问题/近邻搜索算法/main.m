%********认为minAssign的解是精确解**%
clc;clear;
N=15;
steps1=10;steps2=10;
flag=0;
flag1=0;
flag2=zeros(1,steps2);

% fx(:,1)=200.*[1 2 3 4 5 6 7  ]';
% fy(:,1)=-200*[1 2 -1 1 4 -1  6  ]';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=10000+100*[4 5 7 -6 -4 -6 5  ]';
% ty(:,1)=10000+100*[-3 -5 6 -3 -4 8  9  ]';
for t=1:steps1
%    fx(:,t+1)=fx(:,t)+200*[1 1 1  2 3 4 4   ]';
%     fy(:,t+1)=fy(:,t)+200*[-3 -2  -1 1 2 3  2 ]';
    fx(:,t)=500000*rand(1,N)';
    fy(:,t)=500000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
%    tx(:,t+1)=tx(:,t)+70*[4 5 6 5 6 4  4  ]';
%    ty(:,t+1)=ty(:,t)+80*[6 5 4 0 -1 -2 1  ]';
     tx(:,t)=500000*rand(1,N)';
     ty(:,t)=500000*rand(1,N)';
end
for t=1:steps2;
    %************* 威胁矩阵
    Fx=fx(:,t);
    Fy=fy(:,t);
    Mx=mx(:,t);
    My=my(:,t);
    Tx=tx(:,t);
    Ty=ty(:,t);
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
     Val=rand(N,N);
    val_store(:,:,t)=Val;
 
    
    for i=1:N^1.5
         splan(i,:)=randperm(N);
         choosePlan=splan(i,:);
        while 1
            
            choosePlan=search( Val,choosePlan,N );
%             choosePlan=move( Val,choosePlan,N );% 加入移位搜索
            if splan(i,:)==choosePlan 
                flag1=flag1+1;
                break
            end
            splan(i,:)=choosePlan;
            flag2(t)=flag2(t)+1;
        end
        
       
        gains(i)=sum(sum(Val.*codeVal2codeBool(splan(i,:),N)));
     
    end
    
    
    
    ssplan=find(gains==max(gains));
    Splan=splan(ssplan(1),:);
    Smaxval(t)=sum(sum(Val.*codeVal2codeBool(Splan,N)));
    
    L2plan=minAssign(max(max(Val))-Val);
    Lmaxval(t)=sum(sum(Val.*codeVal2codeBool(L2plan,N)));
    
      Lminplan=minAssign(Val);
    Lminval(t)=sum(sum(Val.*codeVal2codeBool(Lminplan,N)));
    
    
end
flag=sum(Lmaxval==Smaxval);
per=flag/steps2

figure(1);
plot((Lmaxval-Smaxval)./Lmaxval,'r')
hold on
legend('误差');

figure(2)
plot(Lmaxval,'ro')
hold on
plot(Smaxval,'b')
legend('精确解','搜索解');

figure(3);
plot((Lmaxval-Smaxval)./(Lmaxval-Lminval),'r')
hold on
plot((Lmaxval-Lminval)./(Lmaxval-Lminval),'b')
hold on
legend('归一化误差','最大归一化误差');





    