
%% -----��һ�׶Σ��ػ�����Ŀ�꣬�������ػ�����ɹ������룬���䵼��------
clear;
clc;
% ����
MaxDisOfMissile = 50*1000;    % ������󹥻�����
% ��ʼ��
obj = MissileAndTarget(5,6,8);
obj = setRand(obj);
% x = get(obj, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(obj);
f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
plan = [];missilePlan = [];

%-----λ�ñ���-------
% ��������
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
        planReal = decodePlanFightersToTargets(obj, planVir); % ����
        obj.FAdvance = mat;% �����������ƾ���
        obj.FTime = matT;
    end
    obj = fighterMoveByPNG(obj, planReal);
    obj = targetMove(obj);
    fightersSave.p(i,:,:) = obj.Fighters.p;
    targetsSave.p(i,:,:) = obj.Targets.p;
    % ����Ƿ����ȫ�����䵼��
    dMT = getDisMatrixOfFighterAndTarget(obj);
    attackFlag = 1; % ��ʼ��ʾ���Է���
    for k=1:size(planReal,2)
        p=planReal(2,k);q=planReal(1,k);   % ������
        if  p~=0  % ��һ��Ϊ0��ʾ������
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
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan); % ����
    end
    obj = missileMoveByPNG(obj, missilePlanReal);
    obj = targetMove(obj);
    targetsSave.p(i,:,:) = obj.Targets.p;
    missilesSave.p(i-stepFighters,:,:) = obj.Missiles.p;
    % ����Ƿ�����Ŀ�궼���ݻ�
    stopFlag = 1;
     for k=1:size(missilePlanReal,2)
        p=missilePlanReal(2,k);q=missilePlanReal(1,k);   % ������
        if  p~=0  % ��һ��Ϊ0��ʾ������
            if obj.Targets.v(q) ~= 0  % ����һ������Ŀ�����ٶȣ�˵������
                stopFlag  = 0;
                break;
            end
        end
    end
    if stopFlag  % Ŀ��ȫ���ݻ�
        steps = i;
        break;
    end
    
end

%%--------plot----------
%-------------ģ��ͼ-------------
figure1 = figure('color',[1 1 1]);
% �ػ�
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
end
% ����
for i=1:obj.numOfMissiles
    x = missilesSave.p(:,i,1);
    y = missilesSave.p(:,i,2);
    plot(x,y,'b');hold on;
end
% Ŀ��
for i=1:obj.numOfTargets
    x = targetsSave.p(:,i,1);
    y = targetsSave.p(:,i,2);
    plot(x,y,'g');hold on;
end

