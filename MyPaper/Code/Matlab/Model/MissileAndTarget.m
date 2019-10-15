
classdef MissileAndTarget
    % 模型
    % 位置角度等参数以及两个阶段的模型
    properties
        numOfFighterPlanes; %载机数量
        numOfTargets; %目标数量
        numOfMissiles; %导弹总数量，
        missileList; % 各个载机的导弹数量
        targetValueList; % 各个目标的价值，价值高的进行多弹协同攻击
        
        FighterPlanes; % 结构体，包含位置，速度，航向角弧度
        Targets;
        Missiles;
    end
    
    % 常量
    properties
        dT = 0.05; % 采样时间0.01s
        maxVOfMissile  = 1500; % 导弹最大速度
        maxVOfFighter = 300; % 载机最大速度 m/s
        maxVOfTarget = 300;
        GOfFighter = 30.0 * 9.8; % 载机横向加速度最大值
        GOfMissile = 60.0 * 9.8; % 导弹的G值
        GOfTarget = 30.0*9.8;
        
    end
    
    methods
        % 构造函数
        function obj = MissileAndTarget(numOfFighterPlanes, numOfTargets, numOfMissiles)
            obj.numOfFighterPlanes = numOfFighterPlanes;
            obj.numOfTargets = numOfTargets;
            obj.numOfMissiles = numOfMissiles;
        end
        
        % 随机设置态势参数
        function obj = setRand(obj)
            obj.FighterPlanes.p =1000 * rand(obj.numOfFighterPlanes, 2);
            obj.FighterPlanes.v = 400* ones(obj.numOfFighterPlanes, 1);
            obj.FighterPlanes.a = rand(obj.numOfFighterPlanes, 1);
            
            obj.Targets.p = 10000+ 10000*rand(obj.numOfTargets, 2);
            obj.Targets.v = 300*ones(obj.numOfTargets, 1);
            obj.Targets.a = 3* ones(obj.numOfTargets, 1);
            
            in = [0,sort(randperm(obj.numOfMissiles-1,obj.numOfFighterPlanes-1)), obj.numOfMissiles]; % [0,numOfMissiles]之间的随机数列, 共numOfFighterPlanes+1个
            obj.missileList = diff(in); % 差数列，后一个元素减去前一个元素组成，这样正好和是 numOfMissiles
            
            % 导弹序列，标记索引处的导弹属于哪个载机，如[1 2 2 3 4]表示索引2,3的导弹属于2号载机
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % 得到导弹的态势参数
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.FighterPlanes.v(orderMissile,:) ;
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
            
            obj.targetValueList = ones(1, obj.numOfTargets);
        end
        
        % 自定义态势参数
        function obj = set(obj, Fighters, Targets, missileList, targetValueList)
            obj.FighterPlanes = Fighters;
            obj.Targets = Targets;
            obj.missileList = missileList;
            obj.targetValueList = targetValueList;
            
            % 导弹序列，标记索引处的导弹属于哪个载机，如[1 2 2 3 4]表示索引2,3的导弹属于2号载机
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % 得到导弹的态势参数
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.maxSpeedOfMissile * ones(obj.numOfMissiles,1);
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
        end
        
        % 计算载机和目标距离矩阵
        function disMatrixOfFighterAndTarget = getDisMatrixOfFighterAndTarget(obj)
            disMatrixOfFighterAndTarget = zeros(obj.numOfFighterPlanes, obj.numOfTargets);
            for i = 1:obj.numOfFighterPlanes
                for j = 1:obj.numOfTargets
                    disMatrixOfFighterAndTarget(i,j) = sqrt(...
                        (obj.FighterPlanes.p(i,1)-obj.Targets.p(j,1))^2 ...
                        +(obj.FighterPlanes.p(i,2)-obj.Targets.p(j,2))^2 ...
                        );
                end
            end
        end
        
        
        % PNG 制导, 第一行目标序列，第二行导弹序列，2*n
        function obj = missileMoveByPNG(obj, plan)
            obj.Missiles.v = obj.maxVOfMissile*ones(obj.numOfMissiles,1);
            missilePlan = zeros(obj.numOfMissiles, 1); % 一个导弹最多攻击1个目标
            for i=1:length(plan)
                missilePlan(plan(2,i)) = plan(1,i);
            end
            % missilePlan
            % 求目标位置
            nextP = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextP(i,:) = obj.Targets.p(missilePlan(i),:);
                end
            end
            % 推算上一时刻导弹位置
            missilePPer = obj.Missiles.p - ...
                [obj.Missiles.v *obj.dT.*cos(obj.Missiles.a), ...
                obj.Missiles.v *obj.dT.*sin(obj.Missiles.a)];
            
            % 推算上一时刻的目标位置
            nextPPer = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextPPer(i,:) = obj.Targets.p(missilePlan(i),:)- ...
                        [obj.Targets.v(missilePlan(i)) *obj.dT.*cos(obj.Targets.a(missilePlan(i))), ...
                        obj.Targets.v(missilePlan(i)) *obj.dT.*sin(obj.Targets.a(missilePlan(i)))];
                end
            end
            % 上一时刻的弹目视线角
            qper = atan2(nextPPer(:,2)-missilePPer(:,2), nextPPer(:,1)-missilePPer(:,1));
            pPNG = 5;
            q = atan2(nextP(:,2)-obj.Missiles.p(:,2), nextP(:,1)-obj.Missiles.p(:,1));
            r = pPNG * (q-qper) + obj.Missiles.a;
            % 导弹移动
            for i = 1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    if((sqrt((obj.Targets.p(missilePlan(i),1)-obj.Missiles.p(i,1)).^2 +...
                        (obj.Targets.p(missilePlan(i),2)-obj.Missiles.p(i,2)).^2) < 20))
                    % 目标被击中，停止移动
                    obj.Targets.v(missilePlan(i),:) = 0;
                    else
                    obj.Missiles.p(i,:) = obj.Missiles.p(i,:) + ...
                       [obj.Missiles.v(i) *obj.dT.*cos(obj.Missiles.a(i)), ...
                        obj.Missiles.v(i) *obj.dT.*sin(obj.Missiles.a(i))];
                    end
                end
            end
  
            obj.Missiles.a = r;
            
        end
        
        % 直接追踪法，载机接近目标,plan为固定目标顺序,2*n,第一行表示目标，第二行表示载机
        function obj = fighterMove(obj, plan)
            fighterPlan = zeros(obj.numOfFighterPlanes, 2); %最多攻击两个目标
            for i=1:length(plan)
                if(fighterPlan(plan(2,i), 1) == 0)
                    fighterPlan(plan(2,i), 1) = plan(1,i);
                else
                    fighterPlan(plan(2,i), 2) = plan(1,i);
                end
            end
            
            %fighterPlan % DEBUG
            % 求载机的下一次移动位置
            nextP = obj.FighterPlanes.p;
            for i=1:obj.numOfFighterPlanes
                if(fighterPlan(i,1)~= 0)
                    nextP(i,:) = obj.Targets.p(fighterPlan(i,1),:);
                end
                if(fighterPlan(i,2)~= 0) % 需要攻击两个目标, 则移到目标为中间位置
                    nextP(i,:) = (nextP(i,:)+obj.Targets.p(fighterPlan(i,1),:))./2;
                end
            end
            %nextP %DEBUG
            % 载机移动
            theta = atan2((nextP(:,2)-obj.FighterPlanes.p(:,2)), nextP(:,1)-obj.FighterPlanes.p(:,1));
            % 如果载机没有攻击目标，其它有目标方向的均值
            % 有目标的载机方向的均值
            sumMeanTheta = 0; k = 0;
            for i=1:obj.numOfFighterPlanes
                if ~(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    sumMeanTheta = sumMeanTheta + theta(i);
                    k = k+1;
                end
            end
            if k~=0
                meanTheta = sumMeanTheta./k;
            end
            % 如果载机没有攻击目标，为其它有目标方向的均值
            for i=1:obj.numOfFighterPlanes
                if(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    theta(i) = meanTheta;
                end
            end
            
            % 航向修正，满足加速度限制
            omiga = obj.GOfFighter./obj.FighterPlanes.v;
            maxTheta = omiga * obj.dT; % 最大转向, 每个载机的不一样，n*1
            for i=1:obj.numOfFighterPlanes
                angle0Vector = [cos(obj.FighterPlanes.a(i)), sin(obj.FighterPlanes.a(i))]; % 原始方向向量形式
                angleDestVector = [cos(theta(i)), sin(theta(i))];
                thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
                if(thetaAngle0WithAngleDest > maxTheta(i))
                    d = obj.FighterPlanes.a(i) + maxTheta(i); % 调整的方向只有两个，只要比较一下即可
                    e = obj.FighterPlanes.a(i) -maxTheta(i);
                    dVector = [cos(d), sin(d)];
                    eVector = [cos(e), sin(e)];
                    % 新的夹角
                    dNewTheta = acos(dot(dVector, angleDestVector)/(norm(dVector)*norm(angleDestVector)));
                    eNewTheta = acos(dot(eVector, angleDestVector)/(norm(eVector)*norm(angleDestVector)));
                    if(dNewTheta < thetaAngle0WithAngleDest)
                        theta(i) = d;
                    else if (eNewTheta < thetaAngle0WithAngleDest)
                            theta(i) = e;
                        end
                    end
                end
            end
            
            % 载机移动
            obj.FighterPlanes.p = obj.FighterPlanes.p+[obj.FighterPlanes.v *obj.dT.*cos(theta), obj.FighterPlanes.v *obj.dT.*sin(theta)];
            obj.FighterPlanes.a = theta;
            
            % 载机对应的导弹移动
            % 导弹序列，标记索引处的导弹属于哪个载机，如[1 2 2 3 4]表示索引2,3的导弹属于2号载机
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % 得到导弹的态势参数
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.FighterPlanes.v(orderMissile,:) ;
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
        end
        
        % 目标移动
        function obj = targeteMove(obj)
            obj.Targets.p = obj.Targets.p + ...
                [obj.Targets.v .*obj.dT.*cos(obj.Targets.a), ...
                obj.Targets.v .*obj.dT.*sin(obj.Targets.a)];
        end
        
        
        
    end
end

