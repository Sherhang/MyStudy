
%% -----第一阶段，载机飞向目标，当所有载机进入可攻击距离，发射导弹------
clear;
clc;
% 常量
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
% 初始化
obj = MissileAndTarget(5,6,8);
obj = setRand(obj);
% x = get(obj, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(obj);
f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
plan = [];missilePlan = [];

%-----位置保存-------
% 迭代次数
stepFighters = 5000;
stepMissiles = 6000;
steps = stepFighters+stepMissiles;
fightersSave.p(1,:,:) = obj.Fighters.p;
targetsSave.p(1,:,:) = obj.Targets.p;
missilesSave.p(1,:,:) = obj.Missiles.p;

i=1;
for i=1:stepFighters
    f1 = getOptmizeMatrixOfFighterAndTarget(obj);
    if  i==1 || rem(i,10)==0   %rem(i,10)==0  % rem%10 == 0
        [mat, matT] =  getOptmizeMatrixOfFighterAndTarget(obj);
        planVir = quantumMinAssign(max(max(mat))-mat);
        planReal = decodePlanFightersToTargets(obj, planVir); % 解码
        obj.FAdvance = mat;% 更新虚拟优势矩阵
        obj.FTime = matT;
    end
    obj = fighterMoveByPNG(obj, planReal);
    obj = targetMove(obj);
    fightersSave.p(i,:,:) = obj.Fighters.p;
    targetsSave.p(i,:,:) = obj.Targets.p;
    % 检查是否可以全部发射导弹
    dMT = getDisMatrixOfFighterAndTarget(obj);
    attackFlag = 1; % 初始表示可以发射
    for k=1:size(planReal,2)
        p=planReal(2,k);q=planReal(1,k);   % 虚拟编号
        if  p~=0  % 有一个为0表示不攻击
            if dMT(p,q) > MaxDisOfMissile
                attackFlag = 0;
                break;
            end
        end
    end
    if attackFlag
        stepFighters = i;
        break;
    end
end

meanF2 = zeros(steps,1);
for i=stepFighters+1:steps
    f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
    if i==stepFighters+1
        mat =  getOptmizeMatrixOfMissileAndTarget(obj);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan); % 解码
    end
    obj = missileMoveByPNG(obj, missilePlanReal);
    obj = targetMove(obj);
    targetsSave.p(i,:,:) = obj.Targets.p;
    missilesSave.p(i-stepFighters,:,:) = obj.Missiles.p;
    % 检查是否所有目标都被摧毁
    stopFlag = 1;
     for k=1:size(missilePlanReal,2)
        p=missilePlanReal(2,k);q=missilePlanReal(1,k);   % 虚拟编号
        if  p~=0  % 有一个为0表示不攻击
            if obj.Targets.v(q) ~= 0  % 任意一个任务目标有速度，说明继续
                stopFlag  = 0;
                break;
            end
        end
    end
    if stopFlag  % 目标全部摧毁
        steps = i;
        break;
    end
    
end

%%--------plot----------
%-------------模型图-------------
figure1 = figure('color',[1 1 1]);
% 载机
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
end
% 导弹
for i=1:obj.numOfMissiles
    x = missilesSave.p(:,i,1);
    y = missilesSave.p(:,i,2);
    plot(x,y,'b');hold on;
end
% 目标
for i=1:obj.numOfTargets
    x = targetsSave.p(:,i,1);
    y = targetsSave.p(:,i,2);
    plot(x,y,'g');hold on;
end

