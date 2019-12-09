% 基于粒子退火遗传的目标分配算法（PSOVFSAGA） TODO
% 暂时先用竞争奖励机制看看效果

% 模拟退火遗传算法，退火对象为变异算子和交叉算子
function [planSAGA, fBestSave,fMeanSave,XcrossSave,XmutateSave, time] = PSOVFSAGA(obj,popsize,steps,Pcross,Pmutate,Top,Dop)
% 输入obj，模型
%         遗传算法的参数，种群数量popsize，迭代次数steps，交叉概率Pcross，变异概率Pmutate，交叉操作选择crossAlg，变异操作选择mutateAlg,
%         Top, 退火初始温度， Dop, 退火衰减系数
%         通常取交叉概率（0.4-0.99，变异概率（0.001-0.2）
%                                                             
% 输出: 十进制编码的解planSAGA，如[2 3 1 4]
%       fBestSave ，每一步最好的解记录
%       fMeanSave , 每一步平均解记录
% test: [planSAGA, fBestSave,fMeanSave, time] = GA1(obj,100,100,1,0.5,"PMX","EM")

tic; % 记录程序开始时间
%-----种群表示方式--------
% s(popsize,numLimit),numLimit表示解的范围，如10*8的矩阵对应1-10的一种排列
% 产生初始种群


Xcross = [1 1 1 1 1]*0.2; % 交叉算子最优解
Xmutate = ones(1,7)*1/7;  % 变异算子最优解
    
algoCross=["PMX","OX1","OX2","CX","PBX"];
algoMutate=["EM","DM","IM","SIM","IVM","SM","LM"];
mutateAlg = algoMutate(1);

numLimit = max(obj.numOfMissiles, sum(obj.targetList));
s = zeros(popsize,numLimit); % 预分配内存
for i=1:popsize
    s(i,:) = randperm(numLimit);
end
% 一些初始变量
fBestSave = zeros(1,steps); % 每一步最好的解记录
fMeanSave = zeros(1,steps); % 每一步平均解记录
fitPop = zeros(popsize,1);    % 每个个体的函数值，即适应度，越大越好
XcrossSave = zeros(steps, 5); % Xcorss 保存
XmutateSave = zeros(steps,7);
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
    
    oldFit = fitPop;
    
    [sSelect,fitPop] =  selectByGamble(s, fitPop); % 选择
    [sCross,fitPop,Xcross] = cross(obj,sSelect, s, fitPop, Pcross,Xcross); % 交叉,同时更新适应度等
    XcrossSave(step,:) = Xcross;
    [sMutate,fitPop] = mutate(obj,sCross, fitPop,Pmutate, mutateAlg); % 变异
    sMutate(randperm(popsize,1),:) = bestPlan; % 最优解取回来
    fitPop(maxIndex) = oldFit(maxIndex);
    
    
    for i=1:popsize   
        % 退火
        if fitPop(i)<oldFit(i)  % 产生了更差的解
            % 该解的接受概率 
            if rand() < exp(-(oldFit(i)-fitPop(i))/Top)
            else  % 不接受，取回原来的
                sMutate(i,:) = s(i,:);
                fitPop(i) = oldFit(i);
            end
        end     
    end
    s = sMutate; % 更新种群
    
    Top = Top*Dop; % 更新温度
end
%%
toc;  % 计时结束
time = toc; % 足够精确
[fBestSave(step+1), maxIndex] =  max(fitPop);
fMeanSave(step+1) = mean(fitPop);
planSAGA = s(maxIndex,:); % 最优解保护
end

%% 轮盘赌选择算子,适应值越大，越容易被选到，最后适应值大的个数多
function [sSelect,newFitPop] =  selectByGamble(s, fitPop)
% 输入：种群s(popsize,numLimit),种群个体的适应值fitPop(popsize,1);
% 输出：选择的种群sSelect(popsize,n)
% test: s=[1 2 3;2 3 1;3 1 2;4 1 3];fitPop = [1 1 4 2];
[popsize, numLimit] = size(s);
sSelect = zeros(popsize, numLimit);
chooseP = fitPop/sum(fitPop); % 各自被选到的概率
chooseP = cumsum(chooseP);  % 每一项为之前所有项之和，如[1 2 3]--> [1 1+2 1+2+3]
randP = rand(5*popsize,1); % 产生足够多的随机数列
k=1;t=1;% k用于选出popsize个个体
newFitPop = fitPop;
while k<=popsize
    for i=1:popsize
        if (randP(t) < chooseP(i))  % 选中第i个
            sSelect(k,:) = s(i,:);
            newFitPop(k) = fitPop(i);
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
%% 轮盘赌选择交叉算子或变异算子
function [alg,p] = selectAlg(algs,fit)
% 输入，algs字符数组，fit自身权重
% 输出，选中的算法名称alg，标号p
popsize = length(algs);
chooseP = fit/sum(fit); % 各自被选到的概率
chooseP = cumsum(chooseP);  % 每一项为之前所有项之和，如[1 2 3]--> [1 1+2 1+2+3]
r = rand();
p =1;alg=algs(1);
for i=1:popsize
    if (r < chooseP(i))  % 选中第i个
        alg = algs(i);
        p = i;
        break;
    end
end

end
%% %% 群体交叉。交叉算子采用选择过后的种群和老种群交叉。或和自身的其它个体交叉，拟采用和自身其它个体交叉
function [sCross,newFitPop,newX] = cross(obj,s1, s2, fitPop, Pcross,X) % s1是选择之后的种群
% 输入：s(popsize,numLimit)老种群，sSelect(popsize,numLimit)选择之后的种群，Pcross交叉概率，crossAlg交叉算子选择,
% X算法的选择概率数列,fitPop对应的个体适应度, obj 模型
% 常数，交叉概率0.4-0.99之间
% 输出：sCross 经过交叉之后的种群, newFitPop新的函数值，newX 新的算法选择概率矩阵


crossAlgs = ["PMX","OX1","OX2","CX","PBX"];
chooseNum = ones(1,5); % 选中该算法的个数,防止除数为0,所有的都加一
upNum = zeros(1,5); % 新解更好的个数

[popsize, numLimit] = size(s1);
sCross = zeros(popsize, numLimit);
s2 = s1(randperm(popsize),:); % 这一句是采用自身交叉，打乱顺序，如果想用和老种群交叉，注释掉即可
pRand = rand(popsize,1);
for i=1:popsize
    chooseNum = ones(1,5); % 选中该算法的个数,防止除数为0,所有的都加一
    upNum = zeros(1,5); % 新解更好的个数
    if pRand(i) < Pcross  % 交叉
        [crossAlg,p] = selectAlg(crossAlgs,X);
        crossHandle = @crossPMX;
        switch crossAlg
            case "PMX"
                crossHandle = @crossPMX;% 函数句柄
            case "OX1"
                crossHandle = @crossOX1;
            case "OX2"
                crossHandle = @crossOX2;
            case "CX"
                crossHandle = @crossCX;
            case "PBX"
                crossHandle = @crossPBX;
        end
%         crossHandle = @crossPMX; % DEBUG
        chooseNum(p) = chooseNum(p)+1; % 选中的次数加一
        [sCross(i,:), ~] = crossHandle(s1(i,:),s2(i,:));  % 交叉
        % 计算交叉之后是否产生了更好的解
        oldF = fitPop(i); % 老的解
        plan = decodeFromHA(obj,sCross(i,:));  % 新的解
        fitPop(i) = ModelFighters(obj, plan);   % 更新新的函数值
        if fitPop(i)>oldF
            upNum(p)=upNum(p)+1;  % 产生更好的解的次数加一
        end
    else
        sCross(i,:) = s1(i,:);
    end
end

deltaX = upNum./chooseNum;
newX = X + 0.01 .* deltaX ; % 0.5速度
newX = newX/sum(newX);  % 归一化
newFitPop = fitPop;
end
%% 群体变异
function [sMutate,newFit] = mutate(obj, s, fitPop, Pmutate,mutateAlg)
if nargin<3
    mutateAlg="EM";
end
switch mutateAlg
    case "EM"
        mutateHandle = @mutateEM;% 函数句柄
    case "DM"
        mutateHandle = @mutateDM;% 函数句柄
    case "IM"
        mutateHandle = @mutateIM;% 函数句柄
    case "SIM"
        mutateHandle = @mutateSIM;% 函数句柄
    case "IVM"
        mutateHandle = @mutateIVM;% 函数句柄
    case "SM"
        mutateHandle = @mutateSM;% 函数句柄
    case "LM"
        mutateHandle = @mutateLM;% 函数句柄
    otherwise
        mutateHandle = @mutateEM;
end
[popsize, ~] = size(s);
sMutate = s;
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pmutate
        sMutate(i,:) = mutateHandle(s(i,:)); % 算子选择
        % 计算交叉之后是否产生了更好的解
%         oldF = fitPop(i); % 老的解
        plan = decodeFromHA(obj,s(i,:));  % 新的解
        fitPop(i) = ModelFighters(obj, plan);   % 更新新的函数值
    end
end
newFit = fitPop;
end

% 基本算子部分
%% PMX交叉法，输入两个解，产生两个新解
function [child1,child2]=crossPMX(s1,s2)
% 输入两个解s1,s2,输出交叉后的解
% s1 = [1 2 3 4 5 6 7 8],s2=[2 4 6 8 7 5 3 1]
% 交叉点选4 6
% child1 =[1     2     3     8     7     5     6     4]
% child2 = [2     8     7     4     5     6     3     1]
bn=size(s1,2);
scro(1,:)=s1;
scro(2,:)=s2;
r = randperm(bn,2); %在[1,bn]范围内随机产生2个交叉位
chb1=min(r); % 这里选择的位置是[chb1+1 : chb2]
chb2=max(r);
middle=scro(1,chb1+1:chb2);
scro(1,chb1+1:chb2)=scro(2,chb1+1:chb2);
scro(2,chb1+1:chb2)=middle;
for i=1:chb1 %似乎有问题
    while find(scro(1,chb1+1:chb2)==scro(1,i))
        zhi=find(scro(1,chb1+1:chb2)==scro(1,i));
        y=scro(2,chb1+zhi);
        scro(1,i)=y;
    end
    while find(scro(2,chb1+1:chb2)==scro(2,i))
        zhi=find(scro(2,chb1+1:chb2)==scro(2,i));
        y=scro(1,chb1+zhi);
        scro(2,i)=y;
    end
end
for i=chb2+1:bn
    while find(scro(1,1:chb2)==scro(1,i))
        zhi=logical(scro(1,1:chb2)==scro(1,i));
        y=scro(2,zhi);
        scro(1,i)=y;
    end
    while find(scro(2,1:chb2)==scro(2,i))
        zhi=logical(scro(2,1:chb2)==scro(2,i));
        y=scro(1,zhi);
        scro(2,i)=y;
    end
end
child1=scro(1,:);
child2=scro(2,:);
end
%% 另一个实现cross_PMX 部分匹配法,原算法有缺陷，目前已经去掉了可能有问题的解
function [child1,child2] = cross_PMX(P1, P2)

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
%% crossOX1 次序交叉法
function [child1,child2]=crossOX1(s1,s2)
% 交叉操作OX1
% 输入，两个解，如s1=[1 2 3 4], s2=[2 4 3 1],随机产生交叉位，如2 4,则交换的是2+1=3:4
% 输出，两个新的解，child1=[ 4 2 3 1],child2 =  [2 1 3 4]
numLimit=length(s1);
r = randperm(numLimit,2); %在[1,numLimit]范围内随机产生2个交叉位
chb1=min(r);
chb2=max(r);
% chb1=2;  % DEBUG
% chb2=5;
% 交换选中的片段,由于剩下的可以不考虑，直接全换
child1 = s2;
child2 = s1;
% 求剩余的部分
c1Left = setdiff(s1, s2(chb1+1:chb2),'stable'); % stable按照s1的顺序返回，否则会排序
c2Left = setdiff(s2, s1(chb1+1:chb2),'stable'); % 
% 填充剩余部分,从后面开始填充，这是和OX1不同的地方
child1(chb2+1:numLimit) = c1Left(1:numLimit-chb2);
child1(1:chb1) = c1Left(length(c1Left)-chb1+1  :length(c1Left));
child2(chb2+1:numLimit) = c2Left(1:numLimit-chb2);
child2(1:chb1) = c2Left(length(c1Left)-chb1+1  :length(c1Left));
end
%% crossOX2 次序交叉法
function [child1,child2]=crossOX2(s1,s2)
% 交叉操作OX2
% 输入，两个解，如s1=[1 2 3 4], s2=[2 4 3 1],随机产生交叉位，如2 4,则交换的是2+1=3:4
% 输出，两个新的解，child1=[ 4 2 3 1],child2 =  [2 1 3 4]
numLimit=length(s1);
r = randperm(numLimit,2); %在[1,numLimit]范围内随机产生2个交叉位
chb1=min(r);
chb2=max(r);
% chb1=2;  % DEBUG
% chb2=5;
% 交换选中的片段,由于剩下的可以不考虑，直接全换
child1 = s2;
child2 = s1;
% 求剩余的部分
c1Left = setdiff(s1, s2(chb1+1:chb2),'stable'); % stable按照s1的顺序返回，否则会排序
c2Left = setdiff(s2, s1(chb1+1:chb2),'stable'); % 
% 填充剩余部分
child1(1:chb1) = c1Left(1:chb1);
child1(chb2+1:numLimit) = c1Left(chb1+1:length(c1Left));
child2(1:chb1) = c2Left(1:chb1);
child2(chb2+1:numLimit) = c2Left(chb1+1:length(c1Left));
end
%% 循环交叉法
function [child1, child2] = crossCX(s1,s2)
numLimit = length(s1);
% 第一步，找一个环，为下标的序号
p = randperm(numLimit,1); % 随机选一个位置
% p = 1; % DEBUG
start = s1(p); % 开始的点
loop = []; % 环的序号
k = 1;
loop(k) = p; % 初始化
while s2(p)~=start && k<numLimit
    k = k+1;
    p = find(s1==s2(p)); % 下一个位置
    loop(k) = p;
end
leftP = setdiff([1:numLimit],loop,'stable'); % 非环的位置
child1 = s1;
child1(leftP) = s2(leftP);
child2 = s2;
child2(leftP) = s1(leftP);
end
%% 基于位置的交叉法
function [child1, child2] = crossPBX(s1,s2)
numLimit = length(s1);
% 第一步，随机选取随机个位置
num = randperm(numLimit,1);
pChoose = sort(randperm(numLimit, num)); % 随机选随机个位置
% pChoose = [2 5 6 9]; %DEBUG
pNChoose = setdiff(1:numLimit, pChoose, 'stable'); % 没有被选中的位置

sPut1 = setdiff(s2,s1(pChoose),'stable'); % 找到s2中元素-s1中被选中的元素
child1 = s1;
child1(pNChoose) = sPut1;

sPut2 = setdiff(s1,s2(pChoose),'stable'); % 找到s2中元素-s1中被选中的元素
child2 = s2;
child2(pNChoose) = sPut2;

end
% 变异算子
%% 交换变异 EM, 
function s2 = mutateEM(s1)
numLimit = size(s1,2);
p= randperm(numLimit,2);
s2 = s1;
s2(p(1)) = s1(p(2));
s2(p(2)) = s1(p(1));
end 
%% 替换变异 DM
function s2 = mutateDM(s1)
% 输入一个解, 输出变换后的解
%  s1 = [1 2 3 4 5]
% 随机选取一段插入到另一个位置，如[2 3]插入到4后面变成[1 4 2 3 5]
numLimit = size(s1,2);
randP = randperm(numLimit,2);% 随机选两个数
p1 = min(randP);
p2 = max(randP);
if p1==1 && p2==numLimit % 防止全选了
    p1=round(numLimit/2);
end
sChoose = s1(p1:p2);
sLeft = [s1(1:p1-1),s1(p2+1:numLimit)];
insertP = randperm(numLimit-(p2-p1+1),1);% 去掉选过的一段，待插入位置
s2 = [sLeft(1:insertP),sChoose,sLeft(insertP+1:numLimit-(p2-p1+1))];
end
%% 插入变异 IM
function s2 = mutateIM(s1)
% 输入一个解, 输出变换后的解
%  s1 = [1 2 3 4 5]
% 随机选取一个插入到另一个位置，如2插入到4后面变成[1 3 4 2 5]
numLimit = size(s1,2);
p1 = randperm(numLimit,1);% 随机选
sLeft = [s1(1:p1-1),s1(p1+1:numLimit)];
p2 = randperm(numLimit-1,1);% 剩下的数组中选一个位置
s2 = [sLeft(1:p2),s1(p1),sLeft(p2+1:numLimit-1)];
end
%% 简单倒位变异 SIM
function s2 = mutateSIM(s1)
% 输入一个解, 输出变换后的解
%  s1 = [1 2 3 4 5]
% 随机选取一段的倒序
numLimit = size(s1,2);
r = randperm(numLimit,2);% 随机选
p1 = min(r);
p2 = max(r);
indexBack = p1:p2;
indexBack = fliplr(indexBack);
s2 = [s1(1:p1-1),s1(indexBack),s1(p2+1:numLimit)];
end
%% 倒位变异 IVM
function s2 = mutateIVM(s1)
% 输入一个解, 输出变换后的解
%  s1 = [1 2 3 4 5]
% 随机选取一段的倒序
numLimit = size(s1,2);
randP = randperm(numLimit,2);% 随机选两个数
p1 = min(randP);
p2 = max(randP);
if p1==1 && p2==numLimit % 防止全选了
    p1=round(numLimit/2);
end
sChoose = s1(p1:p2);
sLeft = [s1(1:p1-1),s1(p2+1:numLimit)];
insertP = randperm(numLimit-(p2-p1+1),1);% 去掉选过的一段，待插入位置
s2 = [sLeft(1:insertP),fliplr(sChoose),sLeft(insertP+1:numLimit-(p2-p1+1))];
end
%% 争夺变异
function s2 = mutateSM(s1)
% 输入一个解, 输出变换后的解
%  s1 = [1 2 3 4 5]
% 随机选取一段，选中的一段，第一个换到子串后面
numLimit = size(s1,2);
randP = randperm(numLimit,2);% 随机选两个数
p1 = min(randP);
p2 = max(randP);
s2=[s1(1:p1-1),s1(p1+1:p2),s1(p1),s1(p2+1:numLimit)];
end
%% 邻接变异
function s2 = mutateLM(s1)
% 选一个和它后面的元素交换
numLimit = size(s1,2);
p1 = randperm(numLimit,1);% 随机选1个数
p2 = p1+1;
if p2 >numLimit
    p2 = p2-1;
end
tmp = s1(p1);
s1(p1) = s1(p2);
s1(p2) = tmp;
s2 = s1;
end