% -------------主程序------------
close all;
% ------------变量部分--------------
popsize = 50;    % 种群规模
vartotal = 2;    % 变量个数
inertia = 0.5;   % 惯性因子
selfw = 2.0;     % 自身因子
globalw = 2.0;   % 全局因子
mutatep = 0.05;  % 变异概率
maxgen = 5000;   % 限定代数
% -----------数组部分-----------------
varrange = [-512 512; -512 512]; % 变量范围。varrange(1,2)表示第一变量的最大值
% ----------粒子群位置初始化-------------
for i=1:popsize
    for j = 1:vartotal
        angle(i,j) = 2*pi*rand;
        chrom(i,1,j) = cos(angle(i,j)); % 第i个粒子的余弦
        chrom(i,2,j) = sin(angle(i,j));
        selfangle(i,j) = 2*pi*rand;
        selfchrom(i,1,j) = cos(angle(i,j)); % 第i个粒子最优位置的余弦
        selfchrom(i,2,j) = sin(angle(i,j));
        dangle(i,j) = 0; % 初始化转角增量
    end
end
% -------------------解空间变换--------------
% 把解变换到解空间范围内，防止超出范围，线性变换
for i=1:popsize
    for j=1:2
        for k = 1:vartotal
            chromx(i,j,k)=0.5*(varrange(k,2)*(1+chrom(i,j,k))+varrange(k,1)*(1-chrom(i,j,k)));
            selfchromx(i,j,k)=0.5*(varrange(k,2)*(1+selfchrom(i,j,k))+varrange(k,1)*(1-selfchrom(i,j,k)));
        end
    end
end
% -----------------计算适应度-----------------
fitness = zeros(popsize,2);
selffitness = zeros(popsize,2);
for i =1 : popsize
    for j = 1:2
        fitness(i,j) = getFitness(chromx(i,j,1), chromx(i,j,2));
        selffitness(i,j) = getFitness(selfchromx(i,j,1), selfchromx(i,j,2));
    end
end
%----------------适应度统计-----------------
minfit = min([fitness(1,1), fitness(1,2)]);
maxfit = fitness(1,2);bestchain=2;
if fitness(1,1)>fitness(1,2)
    maxfit = fitness(1,1);bestchain = 1;
end
minfitindex = 1;
maxfitindex = 1;
avgfit = (fitness(1,1)+fitness(1,2))/(2*popsize);
for i=2:popsize
    for j=1:2
        if minfit > fitness(i,j)
            minfit = fitness(i,j); minfitindex = i;
        end
        if maxfit < fitness(i,j)
            maxfit = fitness(i,j);
            maxfitindex = i;
            bestchain = j;
        end
        avgfit = avgfit + fitness(i,j)/(2*popsize);
    end
end
%---------------初始化全局最优解----------------
gloangle(1,:) = angle(maxfitindex, :);      % 获得全局最优相位
glochrom(1,:,:) = chrom(maxfitindex,:,:);   % 初始化全局最优位置
glchromx(1,:,:) = chromx(maxfitindex,:,:);   % 初始化全局最优位置
glofit = fitness(maxfitindex, bestchain);   % 获得全剧最大适应度
%--------------程序主循环----------------------
for gen = 1:maxgen
    %---------粒子位置移动---------------
    for i=1:popsize
        for j=1:vartotal
            t1 = selfangle(i,j)-angle(i,j);
            if t1 < -pi
                t1 = t1+2*pi;
            end
            if t1 > pi
                t1 = t1-2*pi;
            end
            t2 = gloangle(1,j)-angle(i,j);
            if t2 < -pi
                t2 = t2+2*pi;
            end
            if t2 > pi
                t2 = t2-2*pi;
            end
            dangle(i,j) = inertia* dangle(i,j)+selfw*rand*t1+globalw*rand*t2;
            angle(i,j) = angle(i,j) + dangle(i,j);
            chrom(i,1,j) = cos(angle(i,j));
            chrom(i,2,j) = sin(angle(i,j));
            % 解空间变换
            chromx(i,j,k)=0.5*(varrange(k,2)*(1+chrom(i,j,k))+varrange(k,1)*(1-chrom(i,j,k)));
            selfchromx(i,j,k)=0.5*(varrange(k,2)*(1+selfchrom(i,j,k))+varrange(k,1)*(1-selfchrom(i,j,k)));
        end
        for j=1:2
            fitness(i,j) = getFitness(chromx(i,j,1), chromx(i,j,2));
        end
    end
    %--------粒子位置变异-------------
    for i = 1:popsize
        for j = 1:vartotal
            if rand < mutatep
                angle(i,j) = pi/2-angle(i,j);   % 变异后的相位
                chrom(i,1,j) = cos(angle(i,j));
                chrom(i,2,j) = sin(angle(i,j));
                % 解空间变换
                chromx(i,1,j)=0.5*(varrange(j,2)*(1+chrom(i,1,j))+varrange(j,1)*(1-chrom(i,1,j)));
                chromx(i,2,j)=0.5*(varrange(j,2)*(1+chrom(i,2,j))+varrange(j,1)*(1-chrom(i,2,j)));
            end
        end
%         for j=1:2
%             fitness(i,j) = getFitness(chromx(i,j,1), chromx(i,j,2));
%         end
    end
    %-------------------适应度统计-----------------------
    minfit = min([fitness(1,1), fitness(1,2)]);
    maxfit = fitness(1,2);bestchain=2;
    if fitness(1,1)>fitness(1,2)
        maxfit = fitness(1,1);bestchain = 1;
    end
    minfitindex = 1;
    maxfitindex = 1;
    avgfit = (fitness(1,1)+fitness(1,2))/(2*popsize);
    for i=2:popsize
        for j=1:2
            if minfit > fitness(i,j)
                minfit = fitness(i,j); minfitindex = i;
            end
            if maxfit < fitness(i,j)
                maxfit = fitness(i,j);
                maxfitindex = i;
                bestchain = j;
            end
            avgfit = avgfit + fitness(i,j)/(2*popsize);
        end
    end
    %--------------更新自身的最优位置--------------
    for i=1:popsize
        t1 = max(fitness(i,1),fitness(i,2));
        t2 = max(selffitness(i,1),selffitness(i,2));
        if t1 > t2
            selfangle(i,:) = angle(i,:);
            selfchrom(i,:,:) = chrom(i,:,:);
            selfchromx(i,:,:) = chromx(i,:,:);
            selffitness(i,:) = fitness(i,:);
        end
    end
    %-------------更新全局最优位置--------------------
    if glofit < fitness(maxfitindex, bestchain)
        gloangle(1,:) = angle(maxfitindex, :);      % 获得全局最优相位
        glochrom(1,:,:) = chrom(maxfitindex,:,:);   % 初始化全局最优位置
        glchromx(1,:,:) = chromx(maxfitindex,:,:);  % 初始化全局最优位置
        glofit = fitness(maxfitindex, bestchain);   % 获得全剧最大适应度
    end
    %---------------记录结果------------
    iteration(gen) = gen;
    result(gen) = glofit;
    if result(gen) > 511.73
        break;
    end
end
%---------------主程序结束--------------------
% 画图
bestresult = glofit;
iterationstep = gen;
fprintf('bestresult = %f\n',bestresult);
fprintf('iterationstep = %d\n', iterationstep);
figure(1);
plot(iteration, result);

%--------------适应度函数定义，已知最大值511.73-----------------
function f = getFitness(x,y)
f = -x*sin((abs(y+1-x))^0.5)*cos((abs(y+1+x))^0.5)...
    -(y+1)*cos((abs(y+1-x))^0.5)*sin((abs(y+1+x))^0.5);
end