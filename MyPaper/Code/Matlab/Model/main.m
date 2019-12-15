%% 说明
% 当数目比较大时候，随着模型移动，方案不会变化，如果想看到移动过程中变化方案，将参数设置小一些obj = MissileAndTarget(2,3,4);
% 还可以把总导弹数量设置的比需要攻击的数量少，仿真发现，当虚拟导弹数量大于等于虚拟目标数量，几乎不会发生方案变化的情况。

%% -----第一阶段，载机飞向目标，当所有载机进入可攻击距离，发射导弹------

file = fopen('log.txt','w');
% 常量
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
% 初始化
% obj = MissileAndTarget(7,8,10);
% obj = setRand(obj);
% 自定义态势参数, 请直接加载第一阶段速度4模型数据
% obj.Fighters.p =10*1000 * ones(obj.numOfFighters, 2);
% obj.Fighters.p(:,2) = 5*1000*(1:obj.numOfFighters);
% obj.Fighters.v = 400* ones(obj.numOfFighters, 1);
% obj.Fighters.angle = 0.1*pi*ones(obj.numOfFighters, 1);
% 
% obj.Targets.p = 50*1000+ 10*1000*zeros(obj.numOfTargets, 2);
% obj.Targets.p(:,1) = 50*1000*ones(obj.numOfTargets, 1);
% obj.Targets.p(:,2) = 50*1000+10*1000*(1:obj.numOfTargets)';
% obj.Targets.v = 300*ones(obj.numOfTargets, 1);
% obj.Targets.angle = -20/180*pi*ones(obj.numOfTargets, 1);


% x = get(obj, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(obj);
f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
plan = [];missilePlan = [];

%-----位置保存-------
% 迭代次数
stepFighters = 10000;
stepMissiles = 6000;
steps = stepFighters+stepMissiles;
fightersSave.p(1,:,:) = obj.Fighters.p;
targetsSave.p(1,:,:) = obj.Targets.p;
missilesSave.p(1,:,:) = obj.Missiles.p;
fightersSave.angle(1,:) = obj.Fighters.angle';
targetsSave.angle(1,:) = obj.Targets.angle';
missilesSave.angle(1,:) = obj.Missiles.angle';

% 启发式算法
% 产生初始种群
numLimit = max(obj.numOfMissiles, sum(obj.targetList));
s = zeros(20,numLimit); % 预分配内存
for i=1:20
    s(i,:) = randperm(numLimit);
end
[planHA,s] = SAGA(s,obj,20,200,0.4,0.4, "PMX", "EM",100,0.95);
planVir = decodeFromHA(obj,planHA);
planReal = decodePlanFightersToTargets(obj, planVir)  % 解码
fprintf(file,"targets= ");
fprintf(file,num2str(planReal(1,:)));
fprintf(file,"plan1= ");
fprintf(file,num2str(planReal(2,:)));
fprintf(file,"\n");

i=1;
for i=1:stepFighters
    % 保存变量
    fightersSave.p(i,:,:) = obj.Fighters.p;
    fightersSave.angle(i,:) = obj.Fighters.angle';
    targetsSave.p(i,:,:) = obj.Targets.p;
    targetsSave.angle(i,:,:) = obj.Targets.angle';
    
    f1 = getOptmizeMatrixOfFighterAndTarget(obj);
    %     if  i==1   || rem(i,10000)==0  % rem%10 == 0
    %         [mat, matT] =  getOptmizeMatrixOfFighterAndTarget(obj);
    %         planVir = quantumMinAssign(max(max(mat))-mat);
    %         planReal = decodePlanFightersToTargets(obj, planVir)  % 解码
    %         obj.FAdvance = mat;% 更新虚拟优势矩阵
    %         obj.FTime = matT;
    %     end
    if  i==1   || rem(i,50)==0  % rem%10 == 0  每隔50步重新算一次,即1s 算一次
        [planHA,s]= SAGA(s,obj,20,10,0.4,0.4, "PMX", "EM",1,0.95);
        planVir = decodeFromHA(obj,planHA);
        planReal = decodePlanFightersToTargets(obj, planVir)  % 解码
        fprintf(file,"plan1= ");
        fprintf(file,num2str(planReal(2,:)));
        fprintf(file,"\n");
    end
    obj = fighterMoveByPNG(obj, planReal);
    obj = targetMove(obj);

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


dAng =0.01*(rand(obj.numOfTargets,1)-0.5);  % 目标随机加速度引起的角度变化
for i=stepFighters+1:steps
    targetsSave.p(i,:,:) = obj.Targets.p;
    targetsSave.angle(i,:) = obj.Targets.angle';
    missilesSave.p(i-stepFighters,:,:) = obj.Missiles.p;
    missilesSave.angle(i-stepFighters,:) = obj.Missiles.angle';
    
    f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
    if i==stepFighters+1
        mat =  getOptmizeMatrixOfMissileAndTarget(obj);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan); % 解码
    end
    missilePlanRealPer = missilePlanReal; % 原来的方向
    if rem(i,100)==0 
        mat =  getOptmizeMatrixOfMissileAndTarget(obj);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan) ; % 解码
        if  sum(sum(missilePlanReal~=missilePlanRealPer)) ~= 0  % 且方案真的变了
            if canChange(obj, missilePlanReal) == 0  % 不能改目标，则取回原来的方案
                missilePlanReal=missilePlanRealPer;
            else
                fprintf("Change");fprintf("\n");
                fprintf(file,"Change");fprintf(file,"\n");
                fprintf(file,"oldPlan=");
                fprintf(file,num2str(missilePlanRealPer));fprintf(file,"\n");
                fprintf(file,"currentPlan=");
                fprintf(file,num2str(missilePlanReal));fprintf(file,"\n");
                
            end
        end
    end
    % 目标机动
    obj.Targets.angle = obj.Targets.angle + dAng*obj.dT;
    obj = missileMoveByPNG(obj, missilePlanReal);
    obj = targetMove(obj);

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

%% --------plot----------
%-------------模型图-------------
figure1 = figure('color',[1 1 1]);
% 用来legend
x = fightersSave.p(:,1,1); % 第一架载机
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;
x = missilesSave.p(:,1,1);
y = missilesSave.p(:,1,2);
p2 = plot(x,y,'b');  hold on;
x = targetsSave.p(:,1,1);
y = targetsSave.p(:,1,2);
p3 = plot(x,y,'color','g');hold on;

% 载机
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
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
    plot(x,y,'color','g');hold on;
end
% 箭头
% 载机初始时刻位置的方向
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;
% 导弹初始时刻位置的方向
x = missilesSave.p(1,:,1);
y = missilesSave.p(1,:,2);
quiver(x',y', cos(missilesSave.angle(1,:))',sin(missilesSave.angle(1,:))',0.3,'color','b');
hold on;
% 目标初始时刻的速度方向
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;

legend([p1,p2,p3],["载机","导弹","目标"],'Location','northwest');