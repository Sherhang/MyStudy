
classdef MissileAndTarget
    % 模型
    % 位置角度等参数以及两个阶段的模型
    properties
        numOfFighters; % 载机数量
        numOfTargets;  % 目标数量
        numOfMissiles; % 导弹总数量，
        missileList;   % 各个载机的导弹数量,[1 2 1 2]表示1号载机有一个导弹，2号载机有两个
        targetList;    % 各个目标需要的攻击导弹数量，[1,2,2,1]2号目标和3号目标需要2枚导弹
        
        Fighters; % 结构体，包含位置，速度，航向角弧度
        Targets;
        Missiles;
    end
    
    % 常量
    properties
        dT = 0.02; % 采样时间0.02s
        maxVOfMissile  = 1500; % 导弹最大速度
        maxVOfFighter = 400; % 载机最大速度 m/s
        maxVOfTarget = 300;
        GOfFighter = 30.0 * 9.8; % 载机横向加速度最大值
        GOfMissile = 60.0 * 9.8; % 导弹的G值
        GOfTarget = 30.0*9.8;
    end
    % 计算得到的常量
    properties
        orderMissile = [];
        orderTarget = [];
        Tmax = 10000; % 参考最大攻击时间，这个时间由第一次攻击得到
        FAdvance = []; % 载机优势，虚拟
        MAdvance = []; % 导弹优势，虚拟
        FTime =[]; % 载机估算时间，虚拟
    end
    methods
        % 构造函数
        function obj = MissileAndTarget(numOfFighters, numOfTargets, numOfMissiles)
            obj.numOfFighters = numOfFighters;
            obj.numOfTargets = numOfTargets;
            obj.numOfMissiles = numOfMissiles;
        end
        
        % 随机设置态势参I
        function obj = setRand(obj)
            obj.Fighters.p =30*1000 * rand(obj.numOfFighters, 2);
            obj.Fighters.v = 500* ones(obj.numOfFighters, 1);
            obj.Fighters.angle = pi*rand(obj.numOfFighters, 1);
            
            obj.Targets.p = 35*1000+ 20*1000*rand(obj.numOfTargets, 2);
            obj.Targets.v = 300*ones(obj.numOfTargets, 1);
            obj.Targets.angle = 50/180*pi*rand(obj.numOfTargets, 1);
            
            indexD = randperm(obj.numOfFighters, obj.numOfMissiles-obj.numOfFighters); % 对应位置的载机拥有2枚导弹
            obj.missileList = ones(1,obj.numOfFighters);
            obj.missileList(indexD) = obj.missileList(indexD)+1;
            
            indexE = randperm(obj.numOfTargets, ceil(obj.numOfTargets/4));   % 1/4 对应位置的目标需要2枚导弹
            obj.targetList = ones(1,obj.numOfTargets);
            obj.targetList(indexE) = obj.targetList(indexE)+1;
            
            % 导弹序列，标记索引处的导弹属于哪个载机，如[1 2 2 3 4]表示索引2,3的导弹属于2号载机
            k =1; obj.orderMissile = ones(1, obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    obj.orderMissile(k) = i;
                    k = k+1;
                end
            end
            % 目标序列，[1,2,2,3]表示2号目标需要两枚导弹攻击
            k=1;obj.orderTarget = ones(1,obj.numOfTargets);
            for i=1:length(obj.targetList)
                for j=1:obj.targetList(i)
                    obj.orderTarget(k) = i;
                    k = k+1;
                end
            end
            % 得到导弹的态势参数
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.Fighters.v(obj.orderMissile,:) ;
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
            % 计算载机和目标距离矩阵,初始化Tmax
            disMatrixOfFighterAndTarget = zeros(obj.numOfFighters, obj.numOfTargets);
            for i = 1:obj.numOfFighters
                for j = 1:obj.numOfTargets
                    disMatrixOfFighterAndTarget(i,j) = sqrt(...
                        (obj.Fighters.p(i,1)-obj.Targets.p(j,1))^2 ...
                        +(obj.Fighters.p(i,2)-obj.Targets.p(j,2))^2 ...
                        );
                end
            end
           obj.Tmax = max(max(disMatrixOfFighterAndTarget))/(max(obj.Fighters.v)-min(obj.Targets.v));
           [obj.FAdvance, obj.FTime] = getOptmizeMatrixOfFighterAndTarget(obj);  % 初始化优势和时间矩阵
           obj.MAdvance = getOptmizeMatrixOfMissileAndTarget(obj); % 初始化
            
        end
        
        % y用户自定义态势参数
        function obj = set(obj, Fighters, Targets, missileList, targeList)
            obj.Fighters = Fighters;
            obj.Targets = Targets;
            obj.missileList = missileList;
            obj.targeList = targeList;
            
            % 导弹序列，标记索引处的导弹属于哪个载机，如[1 2 2 3 4]表示索引2,3的导弹属于2号载机
            k =1; obj.orderMissile = ones(1, obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    obj.orderMissile(k) = i;
                    k = k+1;
                end
            end
            % 目标序列，[1,2,2,3]表示2号目标需要两枚导弹攻击
            k=1;obj.orderTarget = ones(1,obj.numOfTargets);
            for i=1:length(obj.targetList)
                for j=1:obj.targetList(i)
                    obj.orderTarget(k) = i;
                    k = k+1;
                end
            end
            % 得到导弹的态势参数
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.maxSpeedOfMissile * ones(obj.numOfMissiles,1);
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
            % 计算载机和目标距离矩阵,初始化Tmax
            disMatrixOfFighterAndTarget = zeros(obj.numOfFighters, obj.numOfTargets);
            for i = 1:obj.numOfFighters
                for j = 1:obj.numOfTargets
                    disMatrixOfFighterAndTarget(i,j) = sqrt(...
                        (obj.Fighters.p(i,1)-obj.Targets.p(j,1))^2 ...
                        +(obj.Fighters.p(i,2)-obj.Targets.p(j,2))^2 ...
                        );
                end
            end
           obj.Tmax = max(max(disMatrixOfFighterAndTarget))/(max(obj.Fighters.v)-min(obj.Targets.v));
           [obj.FAdvance, obj.FTime] = getOptmizeMatrixOfFighterAndTarget(obj);  % 初始化优势和时间矩阵
           obj.MAdvance = getOptmizeMatrixOfMissileAndTarget(obj); % 初始化
        end
        
        % PNG 制导, plan第一行目标实际序号，第二行导弹序号，2*n
        function obj = missileMoveByPNG(obj, plan)
            obj.Missiles.v = obj.maxVOfMissile*ones(obj.numOfMissiles,1);
            missilePlan = zeros(obj.numOfMissiles, 1); % 一个导弹最多攻击1个目标
            for i=1:length(plan)
                if plan(2,i) ~= 0
                    missilePlan(plan(2,i)) = plan(1,i);
                end
            end
%             missilePlan
            % 求目标位置
            nextP = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextP(i,:) = obj.Targets.p(missilePlan(i),:);
                end
            end
            % 推算上一时刻导弹位置
            missilePPer = obj.Missiles.p - ...
                [obj.Missiles.v *obj.dT.*cos(obj.Missiles.angle), ...
                obj.Missiles.v *obj.dT.*sin(obj.Missiles.angle)];
            
            % 推算上一时刻的目标位置
            nextPPer = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextPPer(i,:) = obj.Targets.p(missilePlan(i),:)- ...
                        [obj.Targets.v(missilePlan(i)) *obj.dT.*cos(obj.Targets.angle(missilePlan(i))), ...
                        obj.Targets.v(missilePlan(i)) *obj.dT.*sin(obj.Targets.angle(missilePlan(i)))];
                end
            end
            % 上一时刻的弹目视线角
            qper = atan2(nextPPer(:,2)-missilePPer(:,2), nextPPer(:,1)-missilePPer(:,1));
            pPNG = 5;
            q = atan2(nextP(:,2)-obj.Missiles.p(:,2), nextP(:,1)-obj.Missiles.p(:,1));
            r = pPNG * (q-qper) + obj.Missiles.angle;
            % 导弹移动
            for i = 1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    if((sqrt((obj.Targets.p(missilePlan(i),1)-obj.Missiles.p(i,1)).^2 +...
                            (obj.Targets.p(missilePlan(i),2)-obj.Missiles.p(i,2)).^2) < 30)) % 击落距离30m
                        % 目标被击中，停止移动
                        obj.Targets.v(missilePlan(i),:) = 0;
                    else
                        obj.Missiles.p(i,:) = obj.Missiles.p(i,:) + ...
                            [obj.Missiles.v(i) *obj.dT.*cos(obj.Missiles.angle(i)), ...
                            obj.Missiles.v(i) *obj.dT.*sin(obj.Missiles.angle(i))];
                    end
                end
            end
            
            obj.Missiles.angle = r;
        end
        
        % 直接追踪法，载机接近目标,plan为固定目标顺序,2*n,第一行表示目标，第二行表示载机
        function obj = fighterMove(obj, plan)
            fighterPlan = zeros(obj.numOfFighters, 2); %最多攻击两个目标
            for i=1:length(plan)
                if plan(2,i) == 0   % 该目标不攻击，则跳过
                    continue;
                end
                if(fighterPlan(plan(2,i), 1) == 0)
                    fighterPlan(plan(2,i), 1) = plan(1,i);
                else
                    fighterPlan(plan(2,i), 2) = plan(1,i);
                end
            end
            
%             fighterPlan % DEBUG
            % 求载机的下一次移动位置,假设载机最多攻击2个目标
            nextP = obj.Fighters.p;
            for i=1:obj.numOfFighters
                if(fighterPlan(i,1)~= 0)
                    nextP(i,:) = obj.Targets.p(fighterPlan(i,1),:);
                end
                if(fighterPlan(i,2)~= 0) % 需要攻击两个目标, 则移到目标为中间位置
                    nextP(i,:) = (nextP(i,:)+obj.Targets.p(fighterPlan(i,1),:))./2;
                end
            end
            %nextP %DEBUG
            % 载机移动
            theta = atan2((nextP(:,2)-obj.Fighters.p(:,2)), nextP(:,1)-obj.Fighters.p(:,1));
            % 如果载机没有攻击目标，其它有目标方向的均值
            % 有目标的载机方向的均值
            sumMeanTheta = 0; k = 0; meanTheta = 0;
            for i=1:obj.numOfFighters
                if ~(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    sumMeanTheta = sumMeanTheta + theta(i);
                    k = k+1;
                end
            end
            if k~=0
                meanTheta = sumMeanTheta./k;
            end
            % 如果载机没有攻击目标，为其它有目标方向的均值
            for i=1:obj.numOfFighters
                if(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    theta(i) = meanTheta;
                end
            end
            
            % 航向修正，满足加速度限制
            omiga = obj.GOfFighter./obj.Fighters.v;
            maxTheta = omiga * obj.dT; % 最大转向, 每个载机的不一样，n*1
            for i=1:obj.numOfFighters
                angle0Vector = [cos(obj.Fighters.angle(i)), sin(obj.Fighters.angle(i))]; % 原始方向向量形式
                angleDestVector = [cos(theta(i)), sin(theta(i))];
                thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
                if(thetaAngle0WithAngleDest > maxTheta(i))
                    d = obj.Fighters.angle(i) + maxTheta(i); % 调整的方向只有两个，只要比较一下即可
                    e = obj.Fighters.angle(i) -maxTheta(i);
                    dVector = [cos(d), sin(d)];
                    eVector = [cos(e), sin(e)];
                    % 新的夹角
                    dNewTheta = acos(dot(dVector, angleDestVector)/(norm(dVector)*norm(angleDestVector)));
                    eNewTheta = acos(dot(eVector, angleDestVector)/(norm(eVector)*norm(angleDestVector)));
                    if(dNewTheta < thetaAngle0WithAngleDest)
                        theta(i) = d;
                    else
                        if (eNewTheta < thetaAngle0WithAngleDest)
                            theta(i) = e;
                        end
                    end
                end
            end
            
            % 载机移动
            obj.Fighters.p = obj.Fighters.p+[obj.Fighters.v *obj.dT.*cos(theta), obj.Fighters.v *obj.dT.*sin(theta)];
            obj.Fighters.angle = theta;
            
            % 载机对应的导弹移动
            % 得到导弹的态势参数
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.Fighters.v(obj.orderMissile,:) ;
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
        end
        
        % 目标移动
        function obj = targetMove(obj)
            obj.Targets.p = obj.Targets.p + ...
                [obj.Targets.v .*obj.dT.*cos(obj.Targets.angle), ...
                obj.Targets.v .*obj.dT.*sin(obj.Targets.angle)];
        end
        
        %---------------优化建模---------------
        % 计算载机和目标距离矩阵
        function disMatrixOfFighterAndTarget = getDisMatrixOfFighterAndTarget(obj)
            disMatrixOfFighterAndTarget = zeros(obj.numOfFighters, obj.numOfTargets);
            for i = 1:obj.numOfFighters
                for j = 1:obj.numOfTargets
                    disMatrixOfFighterAndTarget(i,j) = sqrt(...
                        (obj.Fighters.p(i,1)-obj.Targets.p(j,1))^2 ...
                        +(obj.Fighters.p(i,2)-obj.Targets.p(j,2))^2 ...
                        );
                end
            end
        end
        
        % 计算导弹和目标距离矩阵
        function disMatrixOfMissileAndTarget = getDisMatrixOfMissileAndTarget(obj)
            disMatrixOfMissileAndTarget = zeros(obj.numOfMissiles, obj.numOfTargets);
            for i = 1:obj.numOfMissiles
                for j = 1:obj.numOfTargets
                    disMatrixOfMissileAndTarget(i,j) = sqrt(...
                        (obj.Missiles.p(i,1)-obj.Targets.p(j,1))^2 ...
                        +(obj.Missiles.p(i,2)-obj.Targets.p(j,2))^2 ...
                        );
                end
            end
        end
        
        %----模型1，第一阶段，载机与目标--------------
        % output: f m*n 的矩阵，m虚拟载机数，虚拟n目标数
        %         T m*n 的矩阵，表示估算时间矩阵
        
        function [f, T] = getOptmizeMatrixOfFighterAndTarget(obj)  
            dMT = getDisMatrixOfFighterAndTarget(obj);
            f0 = zeros(obj.numOfFighters, obj.numOfTargets);
            obj.Tmax = max(max(dMT))/(max(obj.Fighters.v)-min(obj.Targets.v));% 更新最长参考时间 
            for i=1:obj.numOfFighters
                for j=1:obj.numOfTargets
                    d = dMT(i,j); % 距离
                    a = [cos(obj.Fighters.angle(i)), sin(obj.Fighters.angle(i))]; % 载机方向向量
                    b = [obj.Targets.p(j,1)-obj.Fighters.p(i,1), obj.Targets.p(j,2)-obj.Fighters.p(i,2) ];   % 载机目标视线角向量
                    alpha = acos(dot(a,b)/(norm(a)*norm(b)));  % 方位角[0,pi]
                    a = [cos(obj.Targets.angle(j)), sin(obj.Targets.angle(j))]; % 目标方向向量
                    beta = acos(dot(a,b)/(norm(a)*norm(b)));  % 进入角[0,pi]
                    pv = obj.Fighters.v(i)/obj.Targets.v(j);  % 速度比
                    f0(i,j) =  getFighterAdvance(d,alpha,beta,pv);
                    v = obj.Fighters.v(i) - obj.Targets.v(j)*cos(beta);  % 在方位角方向上的相对速度差，估计值
                    T(i,j) =  d./v;
                end
            end        
            %-----载机可以攻击多个目标，矩阵扩充---------
            % 矩阵扩充、
            f = f0(:,obj.orderTarget);T = T(:,obj.orderTarget);
            f = f(obj.orderMissile,:);T = T(obj.orderMissile,:);
        end
        
        %----模型2，第二阶段，导弹与目标---------------
        function f = getOptmizeMatrixOfMissileAndTarget(obj)
            dMT = getDisMatrixOfMissileAndTarget(obj);
            f0 = zeros(obj.numOfMissiles, obj.numOfTargets);
            for i=1:obj.numOfMissiles
                for j=1:obj.numOfTargets
                    d = dMT(i,j); % 距离
                    a = [cos(obj.Missiles.angle(i)), sin(obj.Missiles.angle(i))]; % 载机方向向量
                    b = [obj.Targets.p(j,1)-obj.Missiles.p(i,1), obj.Targets.p(j,2)-obj.Missiles.p(i,2) ];   % 载机目标视线角向量
                    alpha = acos(dot(a,b)/(norm(a)*norm(b)));  % 方位角[0,pi]
                    a = [cos(obj.Targets.angle(j)), sin(obj.Targets.angle(j))]; % 目标方向向量
                    beta = acos(dot(a,b)/(norm(a)*norm(b)));  % 进入角[0,pi]
                    pv = obj.Missiles.v(i)/obj.Targets.v(j);  % 速度比
                    f0(i,j) =  getMissileAdvance(d,alpha,beta,pv);
                end
            end
 
            % 矩阵扩充、
            f = f0(:,obj.orderTarget);
        end
        
        %---------------载机目标序列解码-----------
        % eg: 矩阵的分配为[1,2,3,4;2,3,1,4]
        %     targetList = [1 2 1];
        %     missileList = [2 2 2];
        %   输出 [1 2 2 3;1 2 1 2]
        function FTPlan = decodePlanFightersToTargets(obj, plan)
           
            FTPlan = plan;
            for i=1:length(obj.orderTarget)
                if plan(1,i) ~= 0
                    FTPlan(1,i) = obj.orderTarget(plan(1,i));
                else
                    FTPlan(1,i) = 0;
                end
            end
            for i=1:length(obj.orderTarget)
                if plan(2,i) ~= 0
                    FTPlan(2,i) = obj.orderMissile(plan(2,i));
                else
                    FTPlan(2,i) = 0;
                end
            end
        end
        
        %---------------导弹目标序列解码-----------
        % eg: 矩阵的分配为[1,2,3,4;2,3,1,4]
        %     targetList = [1 2 1];
        %     missileList = [2 2 2];
        function MTPlan = decodePlanMissilesToTargets(obj, plan)
           
            MTPlan = plan;
            for i=1:length(obj.orderTarget)
                if plan(1,i) ~= 0
                    MTPlan(1,i) = obj.orderTarget(plan(1,i));
                else
                    MTPlan(1,i) = 0;
                end
            end
            
        end
    end
    
end


%% 函数部分
%----------载机的距离优势----------
function f = getFDisAdvance(d)
%常量
MaxDisOfRadar = 100*1000;     % 雷达最大搜索距离
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
MinDisOfMissile = 100;         % 导弹最小攻击距离，小于此距离无法发射导弹
MaxInescapableZone = 25*1000;  % 导弹的不可逃逸区外围
MinInescapableZone = 15*1000;  % 导弹的不可逃逸区最小值
e = exp(1);

if d > MaxDisOfRadar          % 大于雷达搜索距离
    f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % 在导弹最大攻击距离和雷达搜索距离之间
    f = 1.0/e*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % 在不可逃逸区外，且在导弹攻击距离内
    f = e^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % 不可逃逸区内，
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % 小于最小不可逃逸区，大于导弹最小攻击范围
    f = e^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile
    f = 0;
end
end
%----------导弹的距离优势----------
function f = getMDisAdvance(d)
%常量
% MaxDisOfRadar = 100*1000;     % 雷达最大搜索距离
% MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
% MinDisOfMissile = 100;         % 导弹最小攻击距离，小于此距离无法发射导弹
MaxInescapableZone = 25*1000;  % 导弹的不可逃逸区外围
% MinInescapableZone = 15*1000;  % 导弹的不可逃逸区最小值
e = exp(1);
f = e^(-d*e/MaxInescapableZone);
end

% 载机or导弹的方位角优势，输入弧度，输出优势值0-1
function f = getAngleAdvance(fai)
% 常量
MaxFaiOfRadar = 180/180*pi;  % 雷达搜索方位角
MaxFaiOfMissile = 80/180*pi;  % 导弹最大离轴发射角，导弹导引系统最大偏角
MaxFaiOfInescapable = 40/180*pi;  % 导弹不可逃逸区最大偏角

if fai > MaxFaiOfRadar
    f = 0;
end
if fai >= MaxFaiOfMissile && fai <= MaxFaiOfRadar
    f = 0.25*(1-(fai-MaxFaiOfMissile)/(MaxFaiOfRadar-MaxFaiOfMissile));
end
if fai >= MaxFaiOfInescapable && fai < MaxFaiOfMissile
    f = 0.75-(fai-MaxFaiOfInescapable)/2/(MaxFaiOfMissile-MaxFaiOfInescapable);
end
if fai >=0 && fai < MaxFaiOfInescapable
    f = 1-fai/4/MaxFaiOfInescapable;
end
end

%---------载机or导弹的进入角优势---------------
function f = getInAngleAdvance(q)
gama = 10;% 最佳进入角
qDeg = q/pi*180;  % 弧度转化为角度
if qDeg < gama
    f = qDeg/gama;
end
if qDeg >=gama && qDeg <= 180
    f = 1-(qDeg-gama)/(180-gama);
end
end
%-----------角度优势,上面两个合起来---------------
function f = getAAdvance(q, fai)
f = getInAngleAdvance(q)*getAngleAdvance(fai);
end

%---------载机or导弹的速度优势,输入载机速度or导弹速度和目标速度的比值----------------
function f = getSpeedAdvance(pv)
f = 0;
if pv > 3
    f = exp((1-pv/3.0)/10);
end
if pv > 1.5 && pv <= 3
    f = 1;
end
if pv >= 0.6 && pv <= 1.5
    f = -0.5+pv;
end
if pv < 0.6
    f = 0.1;
end
end
%----------载机总优势------
% d 距离，a 方位角，b 进入角，pv, 速度比
function f = getFighterAdvance(d,a,b,pv)  %
f = 0.4*getFDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
% 另一种方案，权重和距离有关，TODO
%f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
end
%----------导弹总优势------
% d 距离，a 方位角，b 进入角，pv, 速度比
function f = getMissileAdvance(d,a,b,pv)  %
f = 0.4*getMDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
% 另一种方案，权重和距离有关，TODO
%f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
end


