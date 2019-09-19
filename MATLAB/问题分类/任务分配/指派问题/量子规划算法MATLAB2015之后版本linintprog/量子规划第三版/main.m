clc;clear;
N=30;
steps1=300;steps2=100;

% fx(:,1)=200.*[1 2 3 4 5 6 7 1 1]';
% fy(:,1)=-200*[1 2 -1 1 4 -1  6 1 1]';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=10000+50*[4 5 7 -6 -4 -6 5 1 1]';
% ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 1 2 ]';
% for t=1:steps1
% %    fx(:,t+1)=fx(:,t)+300*[1 1 1  2 3 4 4  1 2]';
% %     fy(:,t+1)=fy(:,t)+300*[-3 -2  -1 1 2 3 1 2 4]';
%     fx(:,t)=500000*rand(1,N)';
%     fy(:,t)=500000*rand(1,N)';
%    mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
% %    tx(:,t+1)=tx(:,t)+200*[4 5 6 5 6 4  4 1 2]';
% %    ty(:,t+1)=ty(:,t)+200*[6 5 4 0 -1 -2 1 2 3]';
%     tx(:,t)=500000*rand(1,N)';
%     ty(:,t)=500000*rand(1,N)';
% end
for t=1:steps2;
    %************* 威胁矩阵与毁伤概率
%     Fx=fx(:,t);
%     Fy=fy(:,t);
%     Mx=mx(:,t);
%     My=my(:,t);
%     Tx=tx(:,t);
%     Ty=ty(:,t);
%     pro=f_probility(Fx,Fy,Tx,Ty,N);
%     thr=f_threat(Fx,Fy,Tx,Ty,N);
%     thr1=max(thr);
%     thr=repmat(thr1,N,1);
%     Val=pro.*thr;
    Val=rand(N,N);%s随机测试
%      Val(find(Val>0.95))=0.95;  %人为构造固定坍缩方案会出错的问题
%      Val(find(Val>0.5&Val<0.6))=0.55;
%      Val(find(Val<0.2))=0.2;
   %Val=round(10*Val)/10;%输入保留5位小数
    val_store(:,:,t)=Val;
    V01=Val/max(max(Val));%输入标准化0-1范围
    V01=round(100*V01);
    

    plan=minzp(max(max(V01))-V01);
    Bplan=codeBool2codeVal(plan,N);
    Bplan_store(t,:)=Bplan;
    Bmaxval(t)=sum(sum(V01.*plan));
    
    [Qplan,EQplan]=minAssign(10-10*V01+rand(N,N));%linprog误差上限是e-8,故所加噪声应该为e-7以下。可以通过扩大输入变相增大误差范围，此例中误差等效为e-7
    Qplan_store(t,:)=Qplan;
    EQplan_store(:,:,t)=EQplan;
    Qmaxval(t)=sum(sum(V01.*codeVal2codeBool(Qplan,N)));
    EQmaxval(t)=sum(sum(V01.*EQplan));
    
   
  % 线性规划  
%     plan=minLzp(max(max(Val))-Val+0.00001*rand(N,N));
%     Lplan=codeBool2codeVal(plan,N);
%     [m,n]=size(Lplan);
%     Lplan_store(t,1:n)=Lplan;
%     Lmaxval(t)=sum(sum(Val.*plan));
%     
    
    
    
end

%最优值匹配率
flag=sum(abs(Qmaxval-Bmaxval)<=10^-6);
per=flag/steps2


%方案完全一致匹配率
flag1=0;
for i=1:steps2
    if Qplan_store(i,:)-Bplan_store(i,:)==zeros(1,N)
        flag1=flag1+1;
    end
end
per1=flag1/steps2

save 100维1000次随机测试.mat Qmaxval Bmaxval

figure(1);
set(gcf,'color','w');
plot((Qmaxval-Bmaxval),'r')
hold on
% plot((Qmaxval-Bmaxval),'b:.')
% hold on
xlabel('steps');ylabel('error')

% plot(EQmaxval-Bmaxval,'b')
% hold on
% legend('量子规划值-bintprog计算值','量子期望值-bintprog计算值')
%  plot(Lmaxval-Bmaxval,'g')
%  hold on
legend('加噪声干扰的量子规划值与参考值之差')

figure(2)
set(gcf,'color','w');
plot(Bmaxval,'ko');
hold on 
plot(Qmaxval,'r');
% hold on 
% plot(Qmaxval,'b:.');
xlabel('steps');ylabel('最优值')
legend('分支定界法','加噪声干扰的量子规划算法')

