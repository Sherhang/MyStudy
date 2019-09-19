% TSP模拟退火算法
 
    clear
    clc
    time1=clock;
    a = 0.9;       %温度衰减函数的参数
    t0 = 100;        %初始温度
    tf = 0.1;         %终止温度
    t = t0;
    Markov_length = 1000;  %Markov链长度
    N=50;
    Val=rand(N,N);
%     Val=0.1*[7 1 1 7 4 7 6 7 8 5;
%     9 9 8 9 8 9 6 4 3 3;
%     3 7 0 9 1 3 6 5 4 8;
%     1 2 9 7 6 3 6 7 5 5;
%     8 1 6 7 4 9 4 5 7 8;
%     2 6 1 7 5 8 9 9 5 4;
%     4 6 7 10 4 9 10 3 4 7;
%     7 10 4 0 5 7 4 1 3 4;
%     1 4 3 7 5 0 5 9 8 7;
%     6 1 3 1 7 3 5 10 9 0];
    V01=1-Val;
    amount=size(Val,1);

 
sol_new = 1:amount;         %产生初始解，sol_new是每次产生的新解
sol_current = sol_new;      %sol_current是当前解
sol_best = sol_new;         %sol_best是冷却中的最好解
E_current = inf;            %E_current是当前解对应的回路距离
E_best = inf;               %E_best是最优解
p = 1;
 
while t >= tf
   for r = 1:Markov_length      %Markov链长度
    %产生随机扰动
    if(rand < 0.1)
        %两交换,这和标准定义不同，只交换了两个位置
        ind1 = 0;
        ind2 = 0;
        while(ind1 >= ind2)
           ind1 = ceil(rand * amount);
           ind2 = ceil(rand * amount);
        end
        tmp1 = sol_new(ind1);
        sol_new(ind1) = sol_new(ind2);
        sol_new(ind2) = tmp1;
    else
        %三交换
        ind1 = 0;
        ind2 = 0;
        ind3 = 0;
        while( (ind1 == ind2) || (ind1 == ind3) || (ind2 == ind3) || (abs(ind1 -ind2) == 1) )
            ind1 = ceil(rand * amount);%ceil向上取整
            ind2 = ceil(rand * amount);
            ind3 = ceil(rand * amount);
        end
        tmp1 = ind1;
        tmp2 = ind2;
        tmp3 = ind3;
        %确保 ind1 < ind2 < ind3
        s=sort([ind1 ind2 ind3]);
        ind1=s(1);ind2=s(2);ind3=s(3);
%   以下是网上程序的方法，运行效率差不多
%         if(ind1 < ind2) && (ind2 < ind3);
%         elseif(ind1 < ind3) && (ind3 < ind2)
%             ind1 = tmp1; ind2 = tmp3; ind3 = tmp2;
%         elseif(ind2 < ind1) && (ind1 < ind3)
%             ind1 = tmp2; ind2 = tmp1; ind3 = tmp3;
%         elseif(ind2 < ind3) && (ind3 < ind1)
%             ind1 = tmp2; ind2 = tmp3; ind3 = tmp1;
%         elseif(ind3 < ind1) && (ind1 < ind2)
%             ind1 = tmp3; ind2 = tmp1; ind3 = tmp2;
%         elseif(ind3 < ind2) && (ind2 < ind1)
%             ind1 = tmp3; ind2 = tmp2; ind3 = tmp1;
%         end
        % 三交换，不包含选定的边界
        tmplist1 = sol_new((ind1 + 1):(ind2 - 1));
        sol_new((ind1 + 1):(ind1 + (ind3 - ind2 + 1) )) = sol_new((ind2):(ind3));
        sol_new((ind1 + (ind3 - ind2 + 1) + 1):(ind3)) = tmplist1;
    end
    
    %检查是否满足约束
    
    %计算目标函数值（即内能）
   
    E_new=sum(sum(V01.*(codeVal2codeBool(sol_new,amount))));
   
    if E_new < E_current
        E_current = E_new;
        sol_current = sol_new;
        if E_new < E_best
            E_best = E_new;
            sol_best = sol_new;
        end
    else
        %若新解的目标函数值大于当前解，
        %则仅以一定概率接受新解
        if rand < exp(-(E_new - E_current)*100/ t)
            E_current = E_new;
            sol_current = sol_new;
        else
            sol_new = sol_current;
        end
        
    end
   end
 
   t = t * a;      %控制参数t（温度）减少为原来的a倍
end
time2=clock;

sol_best;
SAmax= sum(sum(Val.*(codeVal2codeBool(sol_best,amount))))
%标准值
[Qplan_unique,EQplan,Qminval,Qbad] = minAssign_mplan( V01,3);
Qplan_unique;
Qmax=sum(sum(Val.*(codeVal2codeBool(Qplan_unique(1,:),amount))))
SAmax
time=60*time2(5)-60*time1(5)+time2(6)-time1(6)