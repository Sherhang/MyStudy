% TSP模拟退火算法
% 加入概率修正系数，明显提高了算法性能，要保证终止温度附近只有差别非常小的解可以保留下来。还有一种思路是计算一下退火温度，需要确定两个参数


%% 
city30=[41 94;37 84;54 67;25 62;7 64;2 99;68 58;71 44;54 62;83 69;64 60;18 54;22 60;
    83 46;91 38;25 38;24 42;58 69;71 71;74 78;87 76;18 40;13 40;82 7;62 32;58 35;45 21;41 26;44 35;4 50];%30 cities d'=423.741 by D B Fogel
%%
city50=[31 32;32 39;40 30;37 69;27 68;37 52;38 46;31 62;30 48;21 47;25 55;16 57;
    17 63;42 41;17 33;25 32;5 64;8 52;12 42;7 38;5 25; 10 77;45 35;42 57;32 22;
    27 23;56 37;52 41;49 49;58 48;57 58;39 10;46 10;59 15;51 21;48 28;52 33;
    58 27;61 33;62 63;20 26;5 6;13 13;21 10;30 15;36 16;62 42;63 69;52 64;43 67];%50 cities d'=427.855 by D B Fogel
%%
city75=[48 21;52 26;55 50;50 50;41 46;51 42;55 45;38 33;33 34;45 35;40 37;50 30;
    55 34;54 38;26 13;15 5;21 48;29 39;33 44;15 19;16 19;12 17;50 40;22 53;21 36;
    20 30;26 29;40 20;36 26;62 48;67 41;62 35;65 27;62 24;55 20;35 51;30 50;
    45 42;21 45;36 6;6 25;11 28;26 59;30 60;22 22;27 24;30 20;35 16;54 10;50 15;
    44 13;35 60;40 60;40 66;31 76;47 66;50 70;57 72;55 65;2 38;7 43;9 56;15 56;
    10 70;17 64;55 57;62 57;70 64;64 4;59 5;50 4;60 15;66 14;66 8;43 26];%75 cities d'=549.18 by D B Fogel

city = read_csv("Data/usa13509.csv");
amount=size(city,1);
for i=1:amount
    for j=1:amount
        D(i,j)=((city(i,1)-city(j,1))^2+(city(i,2)-city(j,2))^2)^0.5;
    end
end


a = 0.95;       %温度衰减函数的参数,一般文献取0.9以上
t0 = 100000;        %初始温度
tf = 0.000000001;         %终止温度
t = t0;
flag=0;
Markov_length = 8000;  %Markov链长度

sol_new = 1:amount;         %产生初始解，sol_new是每次产生的新解
sol_current = sol_new;      %sol_current是当前解
sol_best = sol_new;         %sol_best是冷却中的最好解
E_current = inf;            %E_current是当前解对应的回路距离
E_best = inf;               %E_best
dSave = [];k=1;
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
    dSave(k) = E_best;k = k+1;
    t = t * a;      %控制参数t（温度）减少为原来的a倍
end
toc
%编码转换路径，默认从1开始
path=TSPpath_decode( sol_best);
% disp('最优解为:');
% disp(path);
disp('最短距离:');
fprintf('%.5f\n',E_best);

figure(1)
P=city;N=amount;minplan=sol_best;
plot(P(:,1),P(:,2),'ro');
hold on
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)],'color','k');
end
line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)]);
% for i=1:N
%     str=sprintf('%d',i);
%     text(P(i,1)+0.3,P(i,2),str);
% end
figure(2)
plot(dSave)

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

