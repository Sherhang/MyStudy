
classdef MissileAndTarget
    % ģ��
    % λ�ýǶȵȲ����Լ������׶ε�ģ��
    properties
        numOfFighterPlanes; %�ػ�����
        numOfTargets; %Ŀ������
        numOfMissiles; %������������
        missileList; % �����ػ��ĵ�������
        targetValueList; % ����Ŀ��ļ�ֵ����ֵ�ߵĽ��ж൯Эͬ����
        
        FighterPlanes; % �ṹ�壬����λ�ã��ٶȣ�����ǻ���
        Targets;
        Missiles;
    end
    
    % ����
    properties
        dT = 0.05; % ����ʱ��0.01s
        maxVOfMissile  = 1500; % ��������ٶ�
        maxVOfFighter = 300; % �ػ�����ٶ� m/s
        maxVOfTarget = 300;
        GOfFighter = 30.0 * 9.8; % �ػ�������ٶ����ֵ
        GOfMissile = 60.0 * 9.8; % ������Gֵ
        GOfTarget = 30.0*9.8;
        
    end
    
    methods
        % ���캯��
        function obj = MissileAndTarget(numOfFighterPlanes, numOfTargets, numOfMissiles)
            obj.numOfFighterPlanes = numOfFighterPlanes;
            obj.numOfTargets = numOfTargets;
            obj.numOfMissiles = numOfMissiles;
        end
        
        % �������̬�Ʋ���
        function obj = setRand(obj)
            obj.FighterPlanes.p =1000 * rand(obj.numOfFighterPlanes, 2);
            obj.FighterPlanes.v = 400* ones(obj.numOfFighterPlanes, 1);
            obj.FighterPlanes.a = rand(obj.numOfFighterPlanes, 1);
            
            obj.Targets.p = 10000+ 10000*rand(obj.numOfTargets, 2);
            obj.Targets.v = 300*ones(obj.numOfTargets, 1);
            obj.Targets.a = 3* ones(obj.numOfTargets, 1);
            
            in = [0,sort(randperm(obj.numOfMissiles-1,obj.numOfFighterPlanes-1)), obj.numOfMissiles]; % [0,numOfMissiles]֮����������, ��numOfFighterPlanes+1��
            obj.missileList = diff(in); % �����У���һ��Ԫ�ؼ�ȥǰһ��Ԫ����ɣ��������ú��� numOfMissiles
            
            % �������У�����������ĵ��������ĸ��ػ�����[1 2 2 3 4]��ʾ����2,3�ĵ�������2���ػ�
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.FighterPlanes.v(orderMissile,:) ;
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
            
            obj.targetValueList = ones(1, obj.numOfTargets);
        end
        
        % �Զ���̬�Ʋ���
        function obj = set(obj, Fighters, Targets, missileList, targetValueList)
            obj.FighterPlanes = Fighters;
            obj.Targets = Targets;
            obj.missileList = missileList;
            obj.targetValueList = targetValueList;
            
            % �������У�����������ĵ��������ĸ��ػ�����[1 2 2 3 4]��ʾ����2,3�ĵ�������2���ػ�
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.maxSpeedOfMissile * ones(obj.numOfMissiles,1);
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
        end
        
        % �����ػ���Ŀ��������
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
        
        
        % PNG �Ƶ�, ��һ��Ŀ�����У��ڶ��е������У�2*n
        function obj = missileMoveByPNG(obj, plan)
            obj.Missiles.v = obj.maxVOfMissile*ones(obj.numOfMissiles,1);
            missilePlan = zeros(obj.numOfMissiles, 1); % һ��������๥��1��Ŀ��
            for i=1:length(plan)
                missilePlan(plan(2,i)) = plan(1,i);
            end
            % missilePlan
            % ��Ŀ��λ��
            nextP = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextP(i,:) = obj.Targets.p(missilePlan(i),:);
                end
            end
            % ������һʱ�̵���λ��
            missilePPer = obj.Missiles.p - ...
                [obj.Missiles.v *obj.dT.*cos(obj.Missiles.a), ...
                obj.Missiles.v *obj.dT.*sin(obj.Missiles.a)];
            
            % ������һʱ�̵�Ŀ��λ��
            nextPPer = obj.Missiles.p;
            for i=1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    nextPPer(i,:) = obj.Targets.p(missilePlan(i),:)- ...
                        [obj.Targets.v(missilePlan(i)) *obj.dT.*cos(obj.Targets.a(missilePlan(i))), ...
                        obj.Targets.v(missilePlan(i)) *obj.dT.*sin(obj.Targets.a(missilePlan(i)))];
                end
            end
            % ��һʱ�̵ĵ�Ŀ���߽�
            qper = atan2(nextPPer(:,2)-missilePPer(:,2), nextPPer(:,1)-missilePPer(:,1));
            pPNG = 5;
            q = atan2(nextP(:,2)-obj.Missiles.p(:,2), nextP(:,1)-obj.Missiles.p(:,1));
            r = pPNG * (q-qper) + obj.Missiles.a;
            % �����ƶ�
            for i = 1:obj.numOfMissiles
                if(missilePlan(i)~= 0)
                    if((sqrt((obj.Targets.p(missilePlan(i),1)-obj.Missiles.p(i,1)).^2 +...
                        (obj.Targets.p(missilePlan(i),2)-obj.Missiles.p(i,2)).^2) < 20))
                    % Ŀ�걻���У�ֹͣ�ƶ�
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
        
        % ֱ��׷�ٷ����ػ��ӽ�Ŀ��,planΪ�̶�Ŀ��˳��,2*n,��һ�б�ʾĿ�꣬�ڶ��б�ʾ�ػ�
        function obj = fighterMove(obj, plan)
            fighterPlan = zeros(obj.numOfFighterPlanes, 2); %��๥������Ŀ��
            for i=1:length(plan)
                if(fighterPlan(plan(2,i), 1) == 0)
                    fighterPlan(plan(2,i), 1) = plan(1,i);
                else
                    fighterPlan(plan(2,i), 2) = plan(1,i);
                end
            end
            
            %fighterPlan % DEBUG
            % ���ػ�����һ���ƶ�λ��
            nextP = obj.FighterPlanes.p;
            for i=1:obj.numOfFighterPlanes
                if(fighterPlan(i,1)~= 0)
                    nextP(i,:) = obj.Targets.p(fighterPlan(i,1),:);
                end
                if(fighterPlan(i,2)~= 0) % ��Ҫ��������Ŀ��, ���Ƶ�Ŀ��Ϊ�м�λ��
                    nextP(i,:) = (nextP(i,:)+obj.Targets.p(fighterPlan(i,1),:))./2;
                end
            end
            %nextP %DEBUG
            % �ػ��ƶ�
            theta = atan2((nextP(:,2)-obj.FighterPlanes.p(:,2)), nextP(:,1)-obj.FighterPlanes.p(:,1));
            % ����ػ�û�й���Ŀ�꣬������Ŀ�귽��ľ�ֵ
            % ��Ŀ����ػ�����ľ�ֵ
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
            % ����ػ�û�й���Ŀ�꣬Ϊ������Ŀ�귽��ľ�ֵ
            for i=1:obj.numOfFighterPlanes
                if(fighterPlan(i,1)==0 && fighterPlan(i,2)==0)
                    theta(i) = meanTheta;
                end
            end
            
            % ����������������ٶ�����
            omiga = obj.GOfFighter./obj.FighterPlanes.v;
            maxTheta = omiga * obj.dT; % ���ת��, ÿ���ػ��Ĳ�һ����n*1
            for i=1:obj.numOfFighterPlanes
                angle0Vector = [cos(obj.FighterPlanes.a(i)), sin(obj.FighterPlanes.a(i))]; % ԭʼ����������ʽ
                angleDestVector = [cos(theta(i)), sin(theta(i))];
                thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
                if(thetaAngle0WithAngleDest > maxTheta(i))
                    d = obj.FighterPlanes.a(i) + maxTheta(i); % �����ķ���ֻ��������ֻҪ�Ƚ�һ�¼���
                    e = obj.FighterPlanes.a(i) -maxTheta(i);
                    dVector = [cos(d), sin(d)];
                    eVector = [cos(e), sin(e)];
                    % �µļн�
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
            
            % �ػ��ƶ�
            obj.FighterPlanes.p = obj.FighterPlanes.p+[obj.FighterPlanes.v *obj.dT.*cos(theta), obj.FighterPlanes.v *obj.dT.*sin(theta)];
            obj.FighterPlanes.a = theta;
            
            % �ػ���Ӧ�ĵ����ƶ�
            % �������У�����������ĵ��������ĸ��ػ�����[1 2 2 3 4]��ʾ����2,3�ĵ�������2���ػ�
            k =1; orderMissile = ones(1,obj.numOfMissiles);
            for i = 1:length(obj.missileList)
                for j = 1:obj.missileList(i)
                    orderMissile(k) = i;
                    k = k+1;
                end
            end
            % orderMissile %DEBUG
            % �õ�������̬�Ʋ���
            obj.Missiles.p = obj.FighterPlanes.p(orderMissile,:) ;
            obj.Missiles.v = obj.FighterPlanes.v(orderMissile,:) ;
            obj.Missiles.a = obj.FighterPlanes.a(orderMissile,:) ;
        end
        
        % Ŀ���ƶ�
        function obj = targeteMove(obj)
            obj.Targets.p = obj.Targets.p + ...
                [obj.Targets.v .*obj.dT.*cos(obj.Targets.a), ...
                obj.Targets.v .*obj.dT.*sin(obj.Targets.a)];
        end
        
        
        
    end
end

