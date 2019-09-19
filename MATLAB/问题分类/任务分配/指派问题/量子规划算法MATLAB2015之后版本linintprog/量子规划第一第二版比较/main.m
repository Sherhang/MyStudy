clc;clear;
N=10;
steps1=1000;steps2=100;

% fx(:,1)=200.*[1 2 3 4 5 6 7 1 1]';
% fy(:,1)=-200*[1 2 -1 1 4 -1  6 1 1]';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=10000+50*[4 5 7 -6 -4 -6 5 1 1]';
% ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 1 2 ]';
for t=1:steps1
%    fx(:,t+1)=fx(:,t)+300*[1 1 1  2 3 4 4  1 2]';
%     fy(:,t+1)=fy(:,t)+300*[-3 -2  -1 1 2 3 1 2 4]';
    fx(:,t)=600000*rand(1,N)';
    fy(:,t)=600000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
%    tx(:,t+1)=tx(:,t)+200*[4 5 6 5 6 4  4 1 2]';
%    ty(:,t+1)=ty(:,t)+200*[6 5 4 0 -1 -2 1 2 3]';
    tx(:,t)=700000*rand(1,N)';
    ty(:,t)=700000*rand(1,N)';
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
    Val=rand(N,N);%s随机测试
    Val=round(100*Val)/100;
    val_store(:,:,t)=Val;
    V01=Val/max(max(Val));%输入标准化0-1范围
    V01=round(100000*V01)/100000;

%量子规划第一版，固定坍缩方案
    [Qplan1,EQplan1]=minAssign1(1-V01);
    Qplan_store1(t,:)=Qplan1;
    EQplan_store1(:,:,t)=EQplan1;
    Qmaxval1(t)=sum(sum(Val.*codeVal2codeBool(Qplan1,N)));
    EQmaxval1(t)=sum(sum(Val.*EQplan1));
%量子规划第二版，轮盘赌坍缩方案    
    [Qplan2,~]=minAssign(1-V01,500);
    Qplan_store2(t,:)=Qplan2;
    Qmaxval2(t)=sum(sum(Val.*codeVal2codeBool(Qplan2,N)));
  
%分支定界    
    plan=minzp(max(max(Val))-Val);
    Bplan=codeBool2codeVal(plan,N);
    Bplan_store(t,:)=Bplan;
    Bmaxval(t)=sum(sum(Val.*plan));
  
end

%最优值匹配率
flag1=sum(abs(Qmaxval1-Bmaxval)<=10^-5);
per1=flag1/steps2

flag2=sum(abs(Qmaxval2-Bmaxval)<=10^-5);
per2=flag2/steps2

%方案完全一致匹配率
flag11=0;
for i=1:steps2
    if Qplan_store1(i,:)-Bplan_store(i,:)==zeros(1,N)
        flag11=flag11+1;
    end
end
per11=flag11/steps2

flag21=0;
for i=1:steps2
    if Qplan_store2(i,:)-Bplan_store(i,:)==zeros(1,N)
        flag21=flag21+1;
    end
end
per21=flag21/steps2

% 保存变量数据、
save  data100维7范围.mat Qmaxval1 Bmaxval Qmaxval2

figure(1);
set(gcf,'color','w');
plot((Qmaxval1-Bmaxval),'r:.')
hold on

plot(Qmaxval2-Bmaxval,'g:.')
hold on
title('n=10')
xlabel('steps');ylabel('函数值')
legend('基本量子规划算法','模拟坍缩量子规划算法')

figure(2)
set(gcf,'color','w');
plot(Bmaxval,'ko');
hold on 
plot(Qmaxval1,'r:.');
hold on 
plot(Qmaxval2,'b--');
title('n=10')
xlabel('steps');ylabel('函数值')
legend('分支定界法','基本量子规划算法','模拟坍缩量子规划算法')

% figure(3)
% % scrsz = get(0,'ScreenSize');
% % set(gcf,'Position',scrsz);
% plot(Fx,Fy,'b^','markersize',12);
% hold on
% plot(Tx,Ty,'ro','markersize',12);
% for i=1:N
%     h=line([Tx(i),Mx(Qplan1(i))],[Ty(i),My(Qplan1(i))]);
%     hold on
%     set(h,'color','g');
%     
% end
% for i=1:N
%     str=sprintf('%d',i);
%    text(Tx(i),Ty(i),str);
%    text(Fx(i),Fy(i),str);
% end




    