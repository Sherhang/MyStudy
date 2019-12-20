
function [fBest,xBest] = TSPSA(city, t, a, tf, Markov_length)
% SA 求tsp, 输入city（n*2) 
% 输出最短距离 fBest, 路径xBest

amount=size(city,1);
for i=1:amount
    for j=1:amount
        D(i,j)=((city(i,1)-city(j,1))^2+(city(i,2)-city(j,2))^2)^0.5;
    end
end


% a = 0.95;       %温度衰减函数的参数,一般文献取0.9以上
% t0 = 100000;        %初始温度
% tf = 0.01;         %终止温度
% t = t0;
% Markov_length = 6000;  %Markov链长度

flag=0;

sol_new = 1:amount;         %产生初始解，sol_new是每次产生的新解
sol_current = sol_new;      %sol_current是当前解
sol_best = sol_new;         %sol_best是冷却中的最好解
E_current = inf;            %E_current是当前解对应的回路距离
E_best = inf;               %E_best
p = 1;
tic;
while t >= tf
    for r = 1:Markov_length      %Markov链长度
        %产生随机扰动
        if(rand < 0.5)
            %2交换，两个序号之间的数倒序
            ind1 = 0;
            ind2 = 0;
            while(ind1 >= ind2)  %保证1<2
                ind1 = ceil(rand * amount);
                ind2 = ceil(rand * amount);
            end
            %理论上需要确保顺序，但是倒序时结果相当于不操作。提高效率
            %         c=[ind1;ind2];
            %         ind1=min(c);
            %         ind2=max(c);
            temp1=sol_new(ind1:ind2);
            temp1=fliplr(temp1);%倒序
            sol_new(ind1:ind2)=temp1;
        else
            %else if(rand<1)
            %三交换
            ind1 = 0;
            ind2 = 0;
            ind3 = 0;
            while( (ind1 == ind2) || (ind1 == ind3) || (ind2 == ind3) || (abs(ind1 -ind2) == 1) )
                ind1 = ceil(rand * amount);
                ind2 = ceil(rand * amount);
                ind3 = ceil(rand * amount);
            end
            tmp1 = ind1;
            tmp2 = ind2;
            tmp3 = ind3;
            %确保 ind1 < ind2 < ind3
            s=sort([ind1 ind2 ind3]);
            ind1=s(1);ind2=s(2);ind3=s(3);
            tmplist1 = sol_new((ind1 + 1):(ind2 - 1));
            sol_new((ind1 + 1):(ind1 + (ind3 - ind2 + 1) )) = sol_new((ind2):(ind3));
            sol_new((ind1 + (ind3 - ind2 + 1) + 1):(ind3)) = tmplist1;
            
        end
        
        %检查是否满足约束
        
        
        %计算目标函数值（即内能）
        E_new = 0;
        for i = 1:(amount - 1)
            E_new = E_new + D(sol_new(i),sol_new(i + 1));
        end
        %再算上从最后一个城市到第一个城市的距离
        E_new = E_new + D(sol_new(amount),sol_new(1));
        
        if E_new <= E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            %若新解的目标函数值大于当前解，
            %则仅以一定概率接受新解
            if rand < exp(-(E_new - E_current)*100 /t)  %加入修正系数100
                E_current = E_new;
                sol_current = sol_new;
                flag=flag+1;
            else
                sol_new = sol_current;
            end
            
        end
    end
    
    t = t * a;      %控制参数t（温度）减少为原来的a倍
end
toc
%编码转换路径，默认从1开始
xBest = TSPpath_decode( sol_best);
% disp('最优解为:');
% disp(path);
fBest = E_best;
end

function [ path ] =TSPpath_decode( path0 )
%UNTITLED 此处显示有关此函数的摘要
%  路径从1开始算的路径表示
[~,num] = size(path0);
[~,p1]=find(path0==1);
path(1:num-p1+1)=path0(p1:num);
path(num-p1+2:num)=path0(1:p1-1);
  if path(2)>path(num)
    temp1=path(2:num);
    temp1=fliplr(temp1);%倒序
    path(2:num)=temp1;
  end
end

