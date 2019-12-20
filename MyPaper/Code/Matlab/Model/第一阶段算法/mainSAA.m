

T = 100;d =0.95; steps = 200;
Markov_length=20;Pmutate=0.4;
algs = ["EM","DM","IM","SIM","IVM","SM","LM"];
Repetition = 20; % 每个算法的重复次数

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planEM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"EM");
end
fBestSaveEM = mean(fB);
fCurrentSaveEM = mean(fC);
timeEM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planDM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"DM");
end
fBestSaveDM = mean(fB);
fCurrentSaveDM = mean(fC);
timeDM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planIM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"IM");
end
fBestSaveIM = mean(fB);
fCurrentSaveIM = mean(fC);
timeIM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planSIM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"SIM");
end
fBestSaveSIM = mean(fB);
fCurrentSaveSIM = mean(fC);
timeSIM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planIVM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"IVM");
end
fBestSaveIVM = mean(fB);
fCurrentSaveIVM = mean(fC);
timeIVM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planSM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"SM");
end
fBestSaveSM = mean(fB);
fCurrentSaveSM = mean(fC);
timeSM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planLM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"LM");
end
fBestSaveLM = mean(fB);
fCurrentSaveLM = mean(fC);
timeLM = mean(t);

minStepsSAA=zeros(7,1);
fBestSAA=zeros(7,1);
%-------收敛步数---
for i=1:steps
    if abs(fBestSaveEM(i)-fBestSaveEM(steps)) < 0.00001
        minStepSAAEM = i
        minStepsSAA(1) = i;
        fBestSAA(1) = fBestSaveEM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveDM(i)-fBestSaveDM(steps)) < 0.00001
        minStepSAADM = i
        minStepsSAA(2) = i;
        fBestSAA(2) = fBestSaveDM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveIM(i)-fBestSaveIM(steps)) < 0.00001
        minStepSAAIM = i
        minStepsSAA(3) = i;
        fBestSAA(3) = fBestSaveIM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveSIM(i)-fBestSaveSIM(steps)) < 0.00001
        minStepSAASIM = i
        minStepsSAA(4) = i;
        fBestSAA(4) = fBestSaveSIM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveIVM(i)-fBestSaveIVM(steps)) < 0.00001
        minStepSAAIVM = i
        minStepsSAA(5) = i;
        fBestSAA(5) = fBestSaveIVM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveSM(i)-fBestSaveSM(steps)) < 0.00001
        minStepSAASM = i
        minStepsSAA(6) = i;
        fBestSAA(6) = fBestSaveSM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveLM(i)-fBestSaveLM(steps)) < 0.00001
        minStepSAALM = i
        minStepsSAA(7) = i;
        fBestSAA(7) = fBestSaveLM(steps);
        break;
    end
end
timeSAA = [timeEM;timeDM;timeIM;timeSIM;timeIVM;timeSM;timeLM]




%----------plot-------
figure1 = figure('color',[1 1 1]);
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%以（0.2，0.2）为原点，长0.5，宽0.45
% set (gca,'position',[0.1,0.1,0.9,0.8] );
plot(fBestSaveEM );hold on;
plot(fBestSaveDM );hold on;
plot(fBestSaveIM );hold on;
plot(fBestSaveSIM );hold on;
plot(fBestSaveIVM );hold on;
plot(fBestSaveSM );hold on;
plot(fBestSaveLM );hold on;

plot(fCurrentSaveEM);hold on;
plot(fCurrentSaveDM);hold on;
plot(fCurrentSaveIM);hold on;
plot(fCurrentSaveSIM);hold on;
plot(fCurrentSaveIVM);hold on;
plot(fCurrentSaveSM);hold on;
plot(fCurrentSaveLM);hold on;

legend("EM最优值","DM最优值","IM最优值","SIM最优值","IVM最优值","SM最优值","LM最优值",...
    "EM当前值","DM当前值","IM当前值","SIM当前值","IVM当前值","SM当前值","LM当前值");
axis([0 240 0.47 0.54]);xlabel("step");ylabel("适应度");
print(figure1,'-dpng','-r300','./png/SAA.png')   % 保存到工作目录下





%% 函数形式，Simulated annealing algorithm SAA算法 模拟退火算法
function  [sBest, fBestSave, fCurrent, time]  = SAA(obj,t,d,steps,Markov_length, Pmutate,mutateAlg)
% obj 模型 t初始温度，d温度衰减因子，steps迭代次数, Markov_length内部循环次数， Pmutate变异概率，mutateALG算法选择
% [sBest, fBestSave, fCurrent, time] = SAA(obj,100,0.95,200,100,0.4,"mutateDM");plot(fCurrent);hold on;plot(fBestSave);

tic;
if nargin<6
    mutateAlg="DM";
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
        mutateHandle = @mutateSM;
end
numLimit = max(obj.numOfMissiles, sum(obj.targetList)); % 矩阵维数
s = randperm(numLimit); % 初始解
plan = decodeFromHA(obj,s);
f = ModelFighters(obj, plan); % 当前函数值
sBest = s; %记录最优解
fCurrent = zeros(1,steps); % 当前对应的函数值
fBestSave = zeros(1,steps); % 最优解对应的函数值
fBest = f; % 全局最优解
fCurrent(1) = f;fBestSave(1)=f;
% 主循环
for step=2:steps
    fCurrent(step) = f;
    for k=1:Markov_length
        if rand() < Pmutate
            sNew = mutateHandle(s); % 产生新的解  
            planNew = decodeFromHA(obj,sNew);
            fNew = ModelFighters(obj, planNew); % 函数值
            if fNew > f
                fCurrent(step) = fNew;
                sBest = sNew;
                s = sNew;f=fNew;
                if fNew > fBest
                    fBest = fNew;
                end
            else
                if rand() <exp(-(f-fNew)/t) % 以一定概率接受差的解
                    fCurrent(step) = fNew;
                    s = sNew;f=fNew;
                    if fNew > fBest
                        fBest = fNew;
                    end
                end
            end
        end
    end

    fBestSave(step) = fBest;
    t = t*d;
end

toc
time = toc;
end
  
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