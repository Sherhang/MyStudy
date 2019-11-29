% 遗传算法求解第一阶段模型，仿真形式，需要关注的点包括，算法的运行时间，算法的迭代
% 参考MATLAB智能优化算法
% 输入obj，模型
%         遗传算法的参数，种群数量popsize，迭代次数steps，交叉概率Pcross，变异概率Pmutate，交叉操作选择，变异操作选择
% 输出: 十进制编码的解planGA，如[2 3 1 4]
%       fBestSave ，每一步最好的解记录
%       fMeanSave , 每一步平均解记录
% test: [planGA, fBestSave,fMeanSave, time] = GA1(obj,100,100,1,0.5)
function [planGA, fBestSave,fMeanSave, time] = GA1(obj,popsize,steps,Pcross,Pmutate)
%  popsize = 10;steps=100;Pcross=0.5;Pmutate = 0.5;
tic; % 记录程序开始时间
%-----种群表示方式--------
% s(popsize,numLimit),numLimit表示解的范围，如10*8的矩阵对应1-10的一种排列
% 产生初始种群
numLimit = max(obj.numOfMissiles, sum(obj.targetList));
s = zeros(popsize,numLimit); % 预分配内存
for i=1:popsize
    s(i,:) = randperm(numLimit);
end
% 一些初始变量
fBestSave = zeros(1,steps); % 每一步最好的解记录
fMeanSave = zeros(1,steps); % 每一步平均解记录
fitPop = rand(popsize,1);    % 每个个体的函数值，即适应度，越大越好
% 计算适应度函数
for i=1:popsize
    plan = decodeFromHA(obj,s(i,:));
    fitPop(i) = ModelFighters(obj, plan);
end
%% 主循环开始
for step=1:steps
    % 先保存一些重要的变量
    [fBestSave(step), maxIndex] =  max(fitPop);
    bestPlan = s(maxIndex,:); % 最优解保护
    fMeanSave(step) = mean(fitPop);
    sSelect =  selectByGamble(s, fitPop); % 选择
    sCross = cross(sSelect, s, Pcross); % 交叉
    s = mutate(sCross, Pmutate); % 变异
    s(randperm(popsize,1),:) = bestPlan; % 最优解取回来
    % 更新适应度函数，
    for i=1:popsize
        plan = decodeFromHA(obj,s(i,:));
        fitPop(i) = ModelFighters(obj, plan);
    end
end
%%
toc;  % 计时结束
time = toc; % 足够精确
[fBestSave(step+1), maxIndex] =  max(fitPop);
fMeanSave(step+1) = mean(fitPop);
planGA = s(maxIndex,:); % 最优解保护
end

% 基本算子部分
%% 轮盘赌选择算子,适应值越大，越容易被选到，最后适应值大的个数多
% 输入：种群s(popsize,numLimit),种群个体的适应值fitPop(popsize,1);
% 输出：选择的种群sSelect(popsize,n)
% test: s=[1 2 3;2 3 1;3 1 2;4 1 3];fitPop = [1 1 4 2];
function sSelect =  selectByGamble(s, fitPop)
[popsize, numLimit] = size(s);
sSelect = zeros(popsize, numLimit);
chooseP = fitPop/sum(fitPop); % 各自被选到的概率
chooseP = cumsum(chooseP);  % 每一项为之前所有项之和，如[1 2 3]--> [1 1+2 1+2+3]
randP = rand(5*popsize,1); % 产生足够多的随机数列
k=1;t=1;% k用于选出popsize个个体
while k<=popsize
    for i=1:popsize
        if (randP(t) < chooseP(i))  % 选中第i个
            sSelect(k,:) = s(i,:);
            k = k+1;
            break;
        end
    end
    t = t+1;
    if t>5*popsize
        t = t-5*popsize;
    end
end
end
% 
%% 交叉算子采用选择过后的种群和老种群交叉。或和自身的其它个体交叉，拟采用和自身其它个体交叉
% 输入：s(popsize,numLimit)老种群，sSelect(popsize,numLimit)选择之后的种群，Pcross
% 常数，交叉概率0.4-0.99之间
% 输出：sCross 经过交叉之后的种群
function sCross = cross(s1, s2, Pcross) % s1是选择之后的种群
[popsize, numLimit] = size(s1);
sCross = zeros(popsize, numLimit);
s2 = s1(randperm(popsize),:); % 这一句是采用自身交叉，打乱顺序，如果想用和老种群交叉，注释掉即可
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pcross  % 交叉
      [sCross(i,:), ~] = crossPMX(s1(i,:),s2(i,:));
    else
       sCross(i,:) = s1(i,:);
    end
end
end
%% crossPMX 部分匹配法,原算法有缺陷，目前已经去掉了可能有问题的解
function [child1,child2] = crossPMX(P1, P2)

numLimit = size(P1,2);
child1=zeros(1,size(P1,2));
child2=zeros(1,size(P1,2));
for k=1:numLimit  %replace 10 and increase number if here infinity if problem d=0;
    fC1=find(P2);
    for i=1:numLimit  %%replace 10 and increase number if here infinity if problem with r1==r2
        r=randi([2,size(P2,2)-1],1,2); % 随机产生两个置换点
        lo=min(r);
        up=max(r);
        if lo==up
            continue
        else
            break
        end
    end
    for i=lo:up
        child1(i)=P2(fC1(i));
    end
    for i= lo:up
        a=P1(i);%2
        b=child1(i);%5
        G=find(a==child1);
        if isempty(G)&& a~=b
            Z=find(b==P1);
            if child1(Z)==0
                child1(Z)=a;
            else
                t=P2(Z);%7
                Z=find(t==P1);%3
                child1(Z)=a;
            end
        end
    end
    d=find(child1==0);%here deal with matrix size and also embed if the position is already occupied.....
    if (d==0)
        continue
    else
        break
    end
end
for i=1:size(d,2)
    child1(d(i))=P1(d(i));
end
fC2=find(P1);
for k=1:numLimit
    for i=lo:up
        child2(i)=P1(fC2(i));
    end
    for i= lo:up;
        a=P2(i);%7
        b=child2(i);%5
        G=find(a==child2);
        if isempty(G)&& a~=b
            Z=find(b==P2);
            if child2(Z)==0;
                child2(Z)=a;
            else
                t=P1(Z);%7
                Z=find(t==P2);%3
                child2(Z)=a;
            end
        end
    end
    d=find(child2==0);%here deal with matrix size and also embed if the position is already occupied.....
    if (d==0)
        continue
    else
        break
    end
end
for i=1:size(d,2)
    child2(d(i))=P2(d(i));
end
% 以下函数是为了防止PMX算法产生不符合要求的解
tmp = 1:numLimit;
if (sum(sort(child1)==tmp)~=numLimit) || (sum(sort(child2)==tmp)~=numLimit)
        child1 = P2;child2=P1;
end
end
%% 循环交叉法
function [child1, child2] = crossCX()
end
% 变异算子
%% 群体变异
function sMutate = mutate(s, Pmutate)
[popsize, ~] = size(s);
sMutate = s;
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pmutate
        sMutate(i,:) = mutateEM(s(i,:)); % 2-交换变异
    end
end
end
%% 2-交换变异 EM, 
function s2 = mutateEM(s1)
numLimit = size(s1,2);
p= randperm(numLimit,2);
s2 = s1;
s2(p(1)) = s1(p(2));
s2(p(2)) = s1(p(1));
end 