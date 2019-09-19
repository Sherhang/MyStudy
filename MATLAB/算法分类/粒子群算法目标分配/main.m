clear;
clc;
gen=500;
t1=clock;
global popsize; %种群规模
global pop; %种群
global c1; %个体最优导向系数
global c2; %全局最优导向系数\
global gbest;
% global gbest_x; %全局最优解 x 轴坐标
% global gbest_y; %全局最优解 y 轴坐标
% global gbest_z; %全局最优解 z 轴坐标
% global gbest_w; %全局最优解 w 轴坐标
global best_fitness; %最优解
global exetime; %当前迭代次数
global max_velocity; %最大速度
global totaltime;
initial; %程序初始化
for exetime=1:gen
    adapting; %计算适应值
    updatepop; %更新粒子位置
    f(1,exetime)=best_fitness;
    f(2,exetime)=mean(pop(:,46));
end
t2=clock;
i=1:gen;  
plot(i,f(1,i),'r');
hold on
plot(i,f(2,i),'b');
xlabel('steps');
ylabel('函数值');
legend('最优值','种群均值')
solution=gbest
best_fitness
totaltime=t2-t1

