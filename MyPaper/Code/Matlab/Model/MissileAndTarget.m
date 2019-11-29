
classdef MissileAndTarget
    % ģ��
    % λ�ýǶȵȲ����Լ������׶ε�ģ��
    properties
        numOfFighters; % �ػ�����
        numOfTargets;  % Ŀ������
        numOfMissiles; % ������������
        missileList;   % �����ػ��ĵ�������,[1 2 1 2]��ʾ1���ػ���һ��������2���ػ�������
        targetList;    % ����Ŀ����Ҫ�Ĺ�������������[1,2,2,1]2��Ŀ���3��Ŀ����Ҫ2ö����
        
        Fighters; % �ṹ�壬����λ�ã��ٶȣ�����ǻ���
        Targets;
        Missiles;
    end
    
    % ����
    properties
        dT = 0.02; % ����ʱ��0.02s
        maxVOfMissile  = 1500; % ��������ٶ�
        maxVOfFighter = 400; % �ػ�����ٶ� m/s
        maxVOfTarget = 300;
        GOfFighter = 30.0 * 9.8; % �ػ�������ٶ����ֵ
        GOfMissile = 60.0 * 9.8; % ������Gֵ
        GOfTarget = 30.0*9.8;
    end
    % ����õ��ĳ���
    properties
        orderMissile = [];
        orderTarget = [];
        Tmax = 10000; % �ο���󹥻�ʱ�䣬���ʱ���ɵ�һ�ι����õ�
        FAdvance = []; % �ػ����ƣ�����
        MAdvance = []; % �������ƣ�����
        FTime =[]; % �ػ�����ʱ�䣬����
    end
    methods
        % ���캯��
        function obj = MissileAndTarget(numOfFighters, numOfTargets, numOfMissiles)
            obj.numOfFighters = numOfFighters;
            obj.numOfTargets = numOfTargets;
            obj.numOfMissiles = numOfMissiles;
        end
        
        % �������̬�Ʋ�I
        function obj = setRand(obj)
            obj.Fighters.p =30*1000 * rand(obj.numOfFighters, 2);
            obj.Fighters.v = 500* ones(obj.numOfFighters, 1);
            obj.Fighters.angle = pi*rand(obj.numOfFighters, 1);
            
            obj.Targets.p = 35*1000+ 20*1000*rand(obj.numOfTargets, 2);
            obj.Targets.v = 300*ones(obj.numOfTargets, 1);
            obj.Targets.angle = 50/180*pi*rand(obj.numOfTargets, 1);
            
            indexD = randperm(obj.numOfFighters, obj.numOfMissiles-obj.numOfFighters); % ��Ӧλ�õ��ػ�ӵ��2ö����
            obj.missileList = ones(1,obj.numOfFighters);
            obj.missileList(indexD) = obj.missileList(indexD)+1;
            
            indexE = randperm(obj.numOfTargets, ceil(obj.numOfTargets/4));   % 1/4 ��Ӧλ�õ�Ŀ����Ҫ2ö����
            obj.targetList = ones(1,obj.numOfTargets);
            obj.targetList(indexE) = obj.targetList(indexE)+1;
            
            % �������У�����������ĵ��������ĸ��ػ�����[1 2 2 3 4]��ʾ����2,3�ĵ�������2���ػ�
            k =1; obj.orderMissile = ones(1, obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    obj.orderMissile(k) = i;
                    k = k+1;
                end
            end
            % Ŀ�����У�[1,2,2,3]��ʾ2��Ŀ����Ҫ��ö��������
            k=1;obj.orderTarget = ones(1,obj.numOfTargets);
            for i=1:length(obj.targetList)
                for j=1:obj.targetList(i)
                    obj.orderTarget(k) = i;
                    k = k+1;
                end
            end
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.Fighters.v(obj.orderMissile,:) ;
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
            % �����ػ���Ŀ��������,��ʼ��Tmax
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
           [obj.FAdvance, obj.FTime] = getOptmizeMatrixOfFighterAndTarget(obj);  % ��ʼ�����ƺ�ʱ�����
           obj.MAdvance = getOptmizeMatrixOfMissileAndTarget(obj); % ��ʼ��
            
        end
        
        % y�û��Զ���̬�Ʋ���
        function obj = set(obj, Fighters, Targets, missileList, targeList)
            obj.Fighters = Fighters;
            obj.Targets = Targets;
            obj.missileList = missileList;
            obj.targeList = targeList;
            
            % �������У�����������ĵ��������ĸ��ػ�����[1 2 2 3 4]��ʾ����2,3�ĵ�������2���ػ�
            k =1; obj.orderMissile = ones(1, obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    obj.orderMissile(k) = i;
                    k = k+1;
                end
            end
            % Ŀ�����У�[1,2,2,3]��ʾ2��Ŀ����Ҫ��ö��������
            k=1;obj.orderTarget = ones(1,obj.numOfTargets);
            for i=1:length(obj.targetList)
                for j=1:obj.targetList(i)
                    obj.orderTarget(k) = i;
                    k = k+1;
                end
            end
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.maxSpeedOfMissile * ones(obj.numOfMissiles,1);
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
            % �����ػ���Ŀ��������,��ʼ��Tmax
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
           [obj.FAdvance, obj.FTime] = getOptmizeMatrixOfFighterAndTarget(obj);  % ��ʼ�����ƺ�ʱ�����
           obj.MAdvance = getOptmizeMatrixOfMissileAndTarget(obj); % ��ʼ��
        end
        
        % PNG �Ƶ�, plan��һ��Ŀ��ʵ����ţ��ڶ��е�����ţ�2*n
        function obj = missileMoveByPNG(obj, plan)
            obj.Missiles.v = obj.maxVOfMissile*ones(obj.numOfMissiles,1);
            missilePlan = zeros(obj.numOfMissiles, 1); % һ��������๥��1��Ŀ��
            for i=1:length(plan)
                if plan(2,i) ~= 0
                    missilePlan(plan(2,i)) = plan(1,i);
                end
            end
%             missilePlan
            % ��Ŀ��λ��
            nextP = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextP(i,:) = obj.Targets.p(missilePlan(i),:);
                end
            end
            % ������һʱ�̵���λ��
            missilePPer = obj.Missiles.p - ...
                [obj.Missiles.v *obj.dT.*cos(obj.Missiles.angle), ...
                obj.Missiles.v *obj.dT.*sin(obj.Missiles.angle)];
            
            % ������һʱ�̵�Ŀ��λ��
            nextPPer = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextPPer(i,:) = obj.Targets.p(missilePlan(i),:)- ...
                        [obj.Targets.v(missilePlan(i)) *obj.dT.*cos(obj.Targets.angle(missilePlan(i))), ...
                        obj.Targets.v(missilePlan(i)) *obj.dT.*sin(obj.Targets.angle(missilePlan(i)))];
                end
            end
            % ��һʱ�̵ĵ�Ŀ���߽�
            qper = atan2(nextPPer(:,2)-missilePPer(:,2), nextPPer(:,1)-missilePPer(:,1));
            pPNG = 5;
            q = atan2(nextP(:,2)-obj.Missiles.p(:,2), nextP(:,1)-obj.Missiles.p(:,1));
            r = pPNG * (q-qper) + obj.Missiles.angle;
            % �����ƶ�
            for i = 1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    if((sqrt((obj.Targets.p(missilePlan(i),1)-obj.Missiles.p(i,1)).^2 +...
                            (obj.Targets.p(missilePlan(i),2)-obj.Missiles.p(i,2)).^2) < 30)) % �������30m
                        % Ŀ�걻���У�ֹͣ�ƶ�
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
        
        % ֱ��׷�ٷ����ػ��ӽ�Ŀ��,planΪ�̶�Ŀ��˳��,2*n,��һ�б�ʾĿ�꣬�ڶ��б�ʾ�ػ�
        function obj = fighterMove(obj, plan)
            fighterPlan = zeros(obj.numOfFighters, 2); %��๥������Ŀ��
            for i=1:length(plan)
                if plan(2,i) == 0   % ��Ŀ�겻������������
                    continue;
                end
                if(fighterPlan(plan(2,i), 1) == 0)
                    fighterPlan(plan(2,i), 1) = plan(1,i);
                else
                    fighterPlan(plan(2,i), 2) = plan(1,i);
                end
            end
            
%             fighterPlan % DEBUG
            % ���ػ�����һ���ƶ�λ��,�����ػ���๥��2��Ŀ��
            nextP = obj.Fighters.p;
            for i=1:obj.numOfFighters
                if(fighterPlan(i,1)~= 0)
                    nextP(i,:) = obj.Targets.p(fighterPlan(i,1),:);
                end
                if(fighterPlan(i,2)~= 0) % ��Ҫ��������Ŀ��, ���Ƶ�Ŀ��Ϊ�м�λ��
                    nextP(i,:) = (nextP(i,:)+obj.Targets.p(fighterPlan(i,1),:))./2;
                end
            end
            %nextP %DEBUG
            % �ػ��ƶ�
            theta = atan2((nextP(:,2)-obj.Fighters.p(:,2)), nextP(:,1)-obj.Fighters.p(:,1));
            % ����ػ�û�й���Ŀ�꣬������Ŀ�귽��ľ�ֵ
            % ��Ŀ����ػ�����ľ�ֵ
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
            % ����ػ�û�й���Ŀ�꣬Ϊ������Ŀ�귽��ľ�ֵ
            for i=1:obj.numOfFighters
                if(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    theta(i) = meanTheta;
                end
            end
            
            % ����������������ٶ�����
            omiga = obj.GOfFighter./obj.Fighters.v;
            maxTheta = omiga * obj.dT; % ���ת��, ÿ���ػ��Ĳ�һ����n*1
            for i=1:obj.numOfFighters
                angle0Vector = [cos(obj.Fighters.angle(i)), sin(obj.Fighters.angle(i))]; % ԭʼ����������ʽ
                angleDestVector = [cos(theta(i)), sin(theta(i))];
                thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
                if(thetaAngle0WithAngleDest > maxTheta(i))
                    d = obj.Fighters.angle(i) + maxTheta(i); % �����ķ���ֻ��������ֻҪ�Ƚ�һ�¼���
                    e = obj.Fighters.angle(i) -maxTheta(i);
                    dVector = [cos(d), sin(d)];
                    eVector = [cos(e), sin(e)];
                    % �µļн�
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
            
            % �ػ��ƶ�
            obj.Fighters.p = obj.Fighters.p+[obj.Fighters.v *obj.dT.*cos(theta), obj.Fighters.v *obj.dT.*sin(theta)];
            obj.Fighters.angle = theta;
            
            % �ػ���Ӧ�ĵ����ƶ�
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.Fighters.p(obj.orderMissile,:) ;
            obj.Missiles.v = obj.Fighters.v(obj.orderMissile,:) ;
            obj.Missiles.angle = obj.Fighters.angle(obj.orderMissile,:) ;
        end
        
        % Ŀ���ƶ�
        function obj = targetMove(obj)
            obj.Targets.p = obj.Targets.p + ...
                [obj.Targets.v .*obj.dT.*cos(obj.Targets.angle), ...
                obj.Targets.v .*obj.dT.*sin(obj.Targets.angle)];
        end
        
        %---------------�Ż���ģ---------------
        % �����ػ���Ŀ��������
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
        
        % ���㵼����Ŀ��������
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
        
        %----ģ��1����һ�׶Σ��ػ���Ŀ��--------------
        % output: f m*n �ľ���m�����ػ���������nĿ����
        %         T m*n �ľ��󣬱�ʾ����ʱ�����
        
        function [f, T] = getOptmizeMatrixOfFighterAndTarget(obj)  
            dMT = getDisMatrixOfFighterAndTarget(obj);
            f0 = zeros(obj.numOfFighters, obj.numOfTargets);
            obj.Tmax = max(max(dMT))/(max(obj.Fighters.v)-min(obj.Targets.v));% ������ο�ʱ�� 
            for i=1:obj.numOfFighters
                for j=1:obj.numOfTargets
                    d = dMT(i,j); % ����
                    a = [cos(obj.Fighters.angle(i)), sin(obj.Fighters.angle(i))]; % �ػ���������
                    b = [obj.Targets.p(j,1)-obj.Fighters.p(i,1), obj.Targets.p(j,2)-obj.Fighters.p(i,2) ];   % �ػ�Ŀ�����߽�����
                    alpha = acos(dot(a,b)/(norm(a)*norm(b)));  % ��λ��[0,pi]
                    a = [cos(obj.Targets.angle(j)), sin(obj.Targets.angle(j))]; % Ŀ�귽������
                    beta = acos(dot(a,b)/(norm(a)*norm(b)));  % �����[0,pi]
                    pv = obj.Fighters.v(i)/obj.Targets.v(j);  % �ٶȱ�
                    f0(i,j) =  getFighterAdvance(d,alpha,beta,pv);
                    v = obj.Fighters.v(i) - obj.Targets.v(j)*cos(beta);  % �ڷ�λ�Ƿ����ϵ�����ٶȲ����ֵ
                    T(i,j) =  d./v;
                end
            end        
            %-----�ػ����Թ������Ŀ�꣬��������---------
            % �������䡢
            f = f0(:,obj.orderTarget);T = T(:,obj.orderTarget);
            f = f(obj.orderMissile,:);T = T(obj.orderMissile,:);
        end
        
        %----ģ��2���ڶ��׶Σ�������Ŀ��---------------
        function f = getOptmizeMatrixOfMissileAndTarget(obj)
            dMT = getDisMatrixOfMissileAndTarget(obj);
            f0 = zeros(obj.numOfMissiles, obj.numOfTargets);
            for i=1:obj.numOfMissiles
                for j=1:obj.numOfTargets
                    d = dMT(i,j); % ����
                    a = [cos(obj.Missiles.angle(i)), sin(obj.Missiles.angle(i))]; % �ػ���������
                    b = [obj.Targets.p(j,1)-obj.Missiles.p(i,1), obj.Targets.p(j,2)-obj.Missiles.p(i,2) ];   % �ػ�Ŀ�����߽�����
                    alpha = acos(dot(a,b)/(norm(a)*norm(b)));  % ��λ��[0,pi]
                    a = [cos(obj.Targets.angle(j)), sin(obj.Targets.angle(j))]; % Ŀ�귽������
                    beta = acos(dot(a,b)/(norm(a)*norm(b)));  % �����[0,pi]
                    pv = obj.Missiles.v(i)/obj.Targets.v(j);  % �ٶȱ�
                    f0(i,j) =  getMissileAdvance(d,alpha,beta,pv);
                end
            end
 
            % �������䡢
            f = f0(:,obj.orderTarget);
        end
        
        %---------------�ػ�Ŀ�����н���-----------
        % eg: ����ķ���Ϊ[1,2,3,4;2,3,1,4]
        %     targetList = [1 2 1];
        %     missileList = [2 2 2];
        %   ��� [1 2 2 3;1 2 1 2]
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
        
        %---------------����Ŀ�����н���-----------
        % eg: ����ķ���Ϊ[1,2,3,4;2,3,1,4]
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


%% ��������
%----------�ػ��ľ�������----------
function f = getFDisAdvance(d)
%����
MaxDisOfRadar = 100*1000;     % �״������������
MaxDisOfMissile = 50*1000;    % ������󹥻�����
MinDisOfMissile = 100;         % ������С�������룬С�ڴ˾����޷����䵼��
MaxInescapableZone = 25*1000;  % �����Ĳ�����������Χ
MinInescapableZone = 15*1000;  % �����Ĳ�����������Сֵ
e = exp(1);

if d > MaxDisOfRadar          % �����״���������
    f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % �ڵ�����󹥻�������״���������֮��
    f = 1.0/e*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % �ڲ����������⣬���ڵ�������������
    f = e^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % �����������ڣ�
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % С����С���������������ڵ�����С������Χ
    f = e^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile
    f = 0;
end
end
%----------�����ľ�������----------
function f = getMDisAdvance(d)
%����
% MaxDisOfRadar = 100*1000;     % �״������������
% MaxDisOfMissile = 50*1000;    % ������󹥻�����
% MinDisOfMissile = 100;         % ������С�������룬С�ڴ˾����޷����䵼��
MaxInescapableZone = 25*1000;  % �����Ĳ�����������Χ
% MinInescapableZone = 15*1000;  % �����Ĳ�����������Сֵ
e = exp(1);
f = e^(-d*e/MaxInescapableZone);
end

% �ػ�or�����ķ�λ�����ƣ����뻡�ȣ��������ֵ0-1
function f = getAngleAdvance(fai)
% ����
MaxFaiOfRadar = 180/180*pi;  % �״�������λ��
MaxFaiOfMissile = 80/180*pi;  % ����������ᷢ��ǣ���������ϵͳ���ƫ��
MaxFaiOfInescapable = 40/180*pi;  % �����������������ƫ��

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

%---------�ػ�or�����Ľ��������---------------
function f = getInAngleAdvance(q)
gama = 10;% ��ѽ����
qDeg = q/pi*180;  % ����ת��Ϊ�Ƕ�
if qDeg < gama
    f = qDeg/gama;
end
if qDeg >=gama && qDeg <= 180
    f = 1-(qDeg-gama)/(180-gama);
end
end
%-----------�Ƕ�����,��������������---------------
function f = getAAdvance(q, fai)
f = getInAngleAdvance(q)*getAngleAdvance(fai);
end

%---------�ػ�or�������ٶ�����,�����ػ��ٶ�or�����ٶȺ�Ŀ���ٶȵı�ֵ----------------
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
%----------�ػ�������------
% d ���룬a ��λ�ǣ�b ����ǣ�pv, �ٶȱ�
function f = getFighterAdvance(d,a,b,pv)  %
f = 0.4*getFDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
% ��һ�ַ�����Ȩ�غ;����йأ�TODO
%f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
end
%----------����������------
% d ���룬a ��λ�ǣ�b ����ǣ�pv, �ٶȱ�
function f = getMissileAdvance(d,a,b,pv)  %
f = 0.4*getMDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
% ��һ�ַ�����Ȩ�غ;����йأ�TODO
%f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
end


