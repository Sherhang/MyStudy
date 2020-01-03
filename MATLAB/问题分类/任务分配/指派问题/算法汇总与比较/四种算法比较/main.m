%该函数测试四种算法的性能，随机生成方阵，计算每个算法的时间和最优值
%只保存指定数据 save time.mat y1 y2
%function main
%clear;clc;
% 记录日志
fid = fopen('log.txt','a');
t=datetime;
fprintf(fid,datestr(t));
fprintf(fid,'\n');
fclose(fid); 

N=500; %测试维度1-1000
steps=10; %每个算法重复调用次数

time_auction=zeros(1,N);
val_auction=zeros(1,N);
flag=zeros(1,N);  % 拍卖算法迭代次数
%plan_auction=zeros(N,N);
time_munkres=zeros(1,N);
val_munkres=zeros(1,N);
%plan_munkres=zeros(N,N);
time_q=zeros(1,N);
val_q=zeros(1,N);
%plan_q=zeros(N,N);
time_base=zeros(1,N);
val_base=zeros(1,N);
%plan_base=zeros(N,N);

for step=1:steps   
  for i =1:N
    fprintf('第%d轮第%d维数据\n',step,i);
    w=10*rand(i,i);  
    %% 拍卖
     t1=clock;  
     [plan,~,~,flag(i)] = auction( w,10000*i,0.1/(i+1),0) ;  % 拍卖误差0.01/i
     t2=clock;
     sum=0;
     for k =1:i
         if plan(k)>0
             sum=sum+w(plan(k),k);
         else
             fid = fopen('log.txt','a');
             fprintf(fid,'拍卖未完成,问题规模为%d\n',i);
             fclose(fid); 
             break
         end
     end  
    time_auction(i)=time_auction(i)*(step-1)/step+etime(t2,t1)/step;  % 单位秒,算steps次平均时间
    val_auction(i)=sum;  %取最后依次的结果
    %plan_auction(i,1:i)=plan;
    %% 匈牙利
    t1=clock;
    plan = munkres(10-w);
    t2=clock;
     sum=0;
     for k =1:i
         sum=sum+w(k,plan(k)); % 注意反过来
     end  
    time_munkres(i)=time_munkres(i)*(step-1)/step+etime(t2,t1)/step;  % 单位秒,算steps次平均时间
    val_munkres(i)=sum;  %取最后依次的结果
    %plan_munkres(i,1:i)=plan;
    %% 量子规划
    t1=clock;
    plan = q_min_assign(10- w+0.000001*rand(i,i));
    t2=clock;
    sum=0;
     for k =1:i
         sum=sum+w(plan(k),k);
     end  
    time_q(i)=time_q(i)*(step-1)/step+etime(t2,t1)/step;  % 单位秒,算steps次平均时间
    val_q(i)=sum;  %取最后依次的结果
    %plan_q(i,1:i)=plan;
    %% 标准值
    t1=clock;
    plan = base_min_assign(10- w+0.000001*rand(i,i));
    t2=clock;
    sum=0;
     for k =1:i
         sum=sum+w(plan(k),k);
     end  
    time_base(i)=time_q(i)*(step-1)/step+etime(t2,t1)/step;  % 单位秒,算steps次平均时间
    val_base(i)=sum;  %取最后的结果
    %plan_base(i,1:i)=plan;  
  end  
end




%保存数据，谨慎使用
% save time_and_val.mat ...
%     time_auction val_auction time_munkres val_munkres time_q val_q time_base val_base flag
% plot
figure(1)
plot(time_base,'r');
hold on 
plot(time_auction,'g');
hold on
plot(time_munkres,'b')
hold on
plot(time_q,'m')
title('算法执行时间')
legend('base','auction','munkres','Q')

figure(2)
plot(val_base,'r');
hold on 
plot(val_auction,'g');
hold on
plot(val_munkres,'b')
hold on
plot(val_q,'m')
title('最优值')
legend('base','auction','munkres','Q')

figure(3)
plot(1+(val_auction-val_base)./val_base,'r')
hold on
plot(1+(val_munkres-val_base)./val_base,'g')
hold on
plot(1+(val_q-val_base)./val_base,'b')
hold on
title('解的质量')
legend('auction','munkres','Q')

figure(4)
plot(flag)
title('拍卖算法的拍卖次数')