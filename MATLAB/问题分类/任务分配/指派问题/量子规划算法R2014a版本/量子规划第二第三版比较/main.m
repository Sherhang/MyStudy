clc;clear;
N=100;
steps1=1000;steps2=10;

% fx(:,1)=200.*[1 2 3 4 5 6 7 1 1]';
% fy(:,1)=-200*[1 2 -1 1 4 -1  6 1 1]';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=10000+50*[4 5 7 -6 -4 -6 5 1 1]';
% ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 1 2 ]';
for t=1:steps1
%    fx(:,t+1)=fx(:,t)+300*[1 1 1  2 3 4 4  1 2]';
%     fy(:,t+1)=fy(:,t)+300*[-3 -2  -1 1 2 3 1 2 4]';
    fx(:,t)=500000*rand(1,N)';
    fy(:,t)=500000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
%    tx(:,t+1)=tx(:,t)+200*[4 5 6 5 6 4  4 1 2]';
%    ty(:,t+1)=ty(:,t)+200*[6 5 4 0 -1 -2 1 2 3]';
    tx(:,t)=500000*rand(1,N)';
    ty(:,t)=500000*rand(1,N)';
end
for t=1:steps2;
    %************* 威胁矩阵与毁伤概率
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
   % Val=rand(N,N);%s随机测试
    Val=round(100000*Val)/100000;
%     Val(find(Val>0.975))=0.975;
%     Val(find(Val<0.1))=0.1;
    val_store(:,:,t)=Val;
    
 %量子规划第一版，固定坍缩方案
    [Qplan1,EQplan1]=minAssign1(max(max(Val))-Val);
    Qplan_store1(t,:)=Qplan1;
    EQplan_store1(:,:,t)=EQplan1;
    Qmaxval1(t)=sum(sum(Val.*codeVal2codeBool(Qplan1,N)));
    EQmaxval1(t)=sum(sum(Val.*EQplan1));
%量子规划第二版，轮盘赌坍缩方案    
    [Qplan2,~]=minAssign(max(max(Val))-Val);
    Qmaxval2(t)=sum(sum(Val.*codeVal2codeBool(Qplan2,N)));
  
    
%量子规划31版，固定坍缩方案
    [Qplan31,EQplan31]=minAssign1(max(max(Val))-Val+0.00001*rand(N,N));
    Qplan_store31(t,:)=Qplan31;
    EQplan_store31(:,:,t)=EQplan31;
    Qmaxval31(t)=sum(sum(Val.*codeVal2codeBool(Qplan31,N)));
    EQmaxval31(t)=sum(sum(Val.*EQplan31));
%量子规划21版，轮盘赌坍缩方案    
    [Qplan32,~]=minAssign(max(max(Val))-Val+0.00001*rand(N,N));
    Qmaxval32(t)=sum(sum(Val.*codeVal2codeBool(Qplan32,N)));
  
    
    plan=minzp(max(max(Val))-Val);
    Bplan=codeBool2codeVal(plan,N);
    Bplan_store(t,:)=Bplan;
    Bmaxval(t)=sum(sum(Val.*plan));
    
    plan=minLzp(max(max(Val))-Val++0.00001*rand(N,N));
    Lplan=codeBool2codeVal(plan,N);
    [m,n]=size(Lplan);
    Lplan_store(t,1:n)=Lplan;
    Lmaxval(t)=sum(sum(Val.*plan));
  
end

% for t=1:steps2
%     Val=val_store(:,:,i);
%     %量子规划31版，加人为噪声干扰固定坍缩方案
%     [Qplan31,EQplan31]=minAssign1(max(max(Val))-Val+0.00001*rand(N,N));
%     Qplan_store31(t,:)=Qplan31;
%     EQplan_store31(:,:,t)=EQplan31;
%     Qmaxval31(t)=sum(sum(Val.*codeVal2codeBool(Qplan31,N)));
%     EQmaxval31(t)=sum(sum(Val.*EQplan31));
% %量子规划21版，加人为噪声干扰轮盘赌坍缩方案    
%     [Qplan32,~]=minAssign(max(max(Val))-Val+0.00001*rand(N,N));
%     Qmaxval32(t)=sum(sum(Val.*codeVal2codeBool(Qplan32,N)));
% end


flag0=sum(Qmaxval1>=Bmaxval);
per0=flag0/steps2


flag=sum(Qmaxval2==Bmaxval);
per=flag/steps2

flag1=sum(Qmaxval2-Bmaxval>=0);
per1=flag1/steps2

flag2=sum(Qmaxval2-EQmaxval1>=0);
per2=flag2/steps2

flag31=sum(Qmaxval31-Bmaxval>=0);
per31=flag31/steps2

flag32=sum(Qmaxval31-Bmaxval>=0);
per32=flag32/steps2


save 7.20.10.4比较2版.mat Qmaxval1 Qmaxval31 Qmaxval32 Bmaxval Qmaxval2 Fx Fy Tx Ty Mx My Qplan1 N

figure(1);
plot((Qmaxval1-Bmaxval),'r')
hold on

plot(Qmaxval2-Bmaxval,'g:.')
hold on
legend('固定坍缩方案','模拟坍缩方案')
% plot(EQmaxval1-Bmaxval,'b:.')
% hold on
% %legend('固定坍缩方案','模拟坍缩方案','量子期望')
% 
% plot(Lmaxval-Bmaxval,'k');
% legend('固定坍缩方案','模拟坍缩方案','量子期望','加人为干扰线性规划取整')

%legend('量子规划值-bintprog函数计算值','量子期望值-bintprog计算值','线性规划值-bintprog')

figure(2)
plot(Bmaxval,'ko');
hold on 
plot(Qmaxval1,'r:.');
hold on 
plot(Qmaxval2,'b--');

legend('bintprog计算值','固定坍缩方案量子规划值','模拟坍缩方案量子规划值')

figure(3)
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Fx,Fy,'b^','markersize',12);
hold on
plot(Tx,Ty,'ro','markersize',12);
for i=1:N
    h=line([Tx(i),Mx(Qplan1(i))],[Ty(i),My(Qplan1(i))]);
    hold on
    set(h,'color','g');
    
end
for i=1:N
    str=sprintf('%d',i);
   text(Tx(i),Ty(i),str);
   text(Fx(i),Fy(i),str);
end

figure(4);
plot((Qmaxval31-Bmaxval),'r')
hold on

plot(Qmaxval32-Bmaxval,'g:.')
hold on
legend('加人为干扰的固定坍缩方案','加人为干扰的模拟坍缩方案')
% plot(EQmaxval31-Bmaxval,'b:.')
% hold on
% legend('固定坍缩方案','模拟坍缩方案','量子期望')
