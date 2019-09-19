%gen=1;
popsize=100;
max_velocity=8;
best_fitness=0;
% gbest_x=[0 ;0 ;0];
% gbest_y=[0; 0 ;0];
% gbest_z=[0 ;0; 0];
% gbest_w=[0 ;0; 0];
%totaltime=0;
%实数编码
%[1 2 2 1]表示第一个火力单元拦截第一和第四个目标，第二
%个火力单元拦截第二和第三个目标
pop(popsize,47)=0;
%初始化种群，创建 popsize 行 14 列的 0 矩阵
% for i=1:popsize
%pop(1,1:15)=[4     7     2     7     5     5     8     1     1     2     5     3     7     4     3];
for i=1:popsize
    for j=1:15
        pop(i,j)=randpop(8);
    end
    
    for j=16:30
        pop(i,j)=pop(i,j-15);
    end
    for j=31:45
        pop(i,j)=round(rand());
    end
    pop(i,46:47)=[0,0];
end
c1=2;
c2=3;
%pop(1,1:15)=[4     7    1     7     5     3     8     2     1     7     5     3     7     4     3];

% % pop(i,1)=randpop(2); %初始化种群中第一个粒子位置
% % pop(i,2)=randpop(2);
% % pop(i,3)=randpop(2);
% % pop(i,4)=randpop(2);
% pop(i,5)=pop(i,1);
% %初始状态下 ，个体最优值等于初始位置
% pop(i,6)=pop(i,2);
% pop(i,7)=pop(i,3);
% pop(i,8)=pop(i,4);
% pop(i,9)=round(rand()); %初始化粒子速度 ，值为 1
% pop(i,10)=round(rand());
% pop(i,11)=round(rand());
% pop(i,12)=round(rand());
% pop(i,13)=0;
% pop(i,14)=0;
% end
c1=3;
c2=2;
% gbest_x(1)=pop(1,1);%全局最优初始值为种群第一个粒子的位置
% gbest_y(1)=pop(1,2);
% gbest_z(1)=pop(1,3);
% gbest_w(1)=pop(1,4);
