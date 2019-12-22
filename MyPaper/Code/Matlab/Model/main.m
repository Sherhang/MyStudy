%% ˵��
% ����Ŀ�Ƚϴ�ʱ������ģ���ƶ�����������仯������뿴���ƶ������б仯����������������СһЩobj = MissileAndTarget(2,3,4);
% �����԰��ܵ����������õı���Ҫ�����������٣����淢�֣������⵼���������ڵ�������Ŀ���������������ᷢ�������仯�������

%% -----��һ�׶Σ��ػ�����Ŀ�꣬�������ػ�����ɹ������룬���䵼��------

file = fopen('log.txt','w');
% ����
MaxDisOfMissile = 50*1000;    % ������󹥻�����
% ��ʼ��
obj = MissileAndTarget(20,35,40);
obj = setRand(obj);
% �Զ���̬�Ʋ���, ��ֱ�Ӽ��ص�һ�׶��ٶ�4ģ������
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

%-----λ�ñ���-------
% ��������
stepFighters = 10000;
stepMissiles = 6000;
steps = stepFighters+stepMissiles;
fightersSave.p(1,:,:) = obj.Fighters.p;
targetsSave.p(1,:,:) = obj.Targets.p;
missilesSave.p(1,:,:) = obj.Missiles.p;
fightersSave.angle(1,:) = obj.Fighters.angle';
targetsSave.angle(1,:) = obj.Targets.angle';
missilesSave.angle(1,:) = obj.Missiles.angle';

% ����ʽ�㷨
% ������ʼ��Ⱥ
numLimit = max(obj.numOfMissiles, sum(obj.targetList));
s = zeros(20,numLimit); % Ԥ�����ڴ�
for i=1:20
    s(i,:) = randperm(numLimit);
end
[planHA,s] = SAGA(s,obj,20,200,0.4,0.4, "PMX", "EM",100,0.95);
planVir = decodeFromHA(obj,planHA);
planReal = decodePlanFightersToTargets(obj, planVir)  % ����
fprintf(file,"targets= ");
fprintf(file,num2str(planReal(1,:)));
fprintf(file,"\n plan1= \n");
fprintf(file,num2str(planReal(2,:)));
fprintf(file,"\n");

i=1;
for i=1:stepFighters
    % �������
    fightersSave.p(i,:,:) = obj.Fighters.p;
    fightersSave.angle(i,:) = obj.Fighters.angle';
    targetsSave.p(i,:,:) = obj.Targets.p;
    targetsSave.angle(i,:,:) = obj.Targets.angle';
    
    f1 = getOptmizeMatrixOfFighterAndTarget(obj);
        if  i==1   %|| rem(i,50)==0  % rem%10 == 0
            [mat, matT] =  getOptmizeMatrixOfFighterAndTarget(obj);
            planVir = quantumMinAssign(max(max(mat))-mat);
            planReal = decodePlanFightersToTargets(obj, planVir)  % ����
            obj.FAdvance = mat;% �����������ƾ���
            obj.FTime = matT;
        end
    if  i==1   || rem(i,50)==0  % rem%10 == 0  ÿ��50��������һ��,��1s ��һ��
        [planHA,s]= SAGA(s,obj,20,10,0.4,0.4, "PMX", "EM",1,0.95);
        planVir = decodeFromHA(obj,planHA);
        planReal = decodePlanFightersToTargets(obj, planVir)  % ����
        % ������
        cc = planReal(2,:);
        for ccx =1:length(cc)
            fprintf(file,"| ");
            fprintf(file,'%d',cc(ccx));
        end
        fprintf(file,"| \n");
        % ������end
%         fprintf(file,num2str(planReal(2,:)));
%         fprintf(file,"\n");
    end
    obj = fighterMoveByPNG(obj, planReal);
    obj = targetMove(obj);

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


dAng =0.05*(rand(obj.numOfTargets,1)-0.5);  % Ŀ��������ٶ�����ĽǶȱ仯
for i=stepFighters+1:steps
    targetsSave.p(i,:,:) = obj.Targets.p;
    targetsSave.angle(i,:) = obj.Targets.angle';
    missilesSave.p(i-stepFighters,:,:) = obj.Missiles.p;
    missilesSave.angle(i-stepFighters,:) = obj.Missiles.angle';
    
    f2 =  getOptmizeMatrixOfMissileAndTarget(obj);
    if i==stepFighters+1
        mat =  getOptmizeMatrixOfMissileAndTarget(obj);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan); % ����
        fprintf(file,"\n\n\n missilePlan0=");
        fprintf(file,num2str(missilePlanReal(2,:)));fprintf(file,"\n");
    end
    missilePlanRealPer = missilePlanReal; % ԭ���ķ���
    if rem(i,50)==0 
        mat =  getOptmizeMatrixOfMissileAndTarget(obj);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlanReal = decodePlanMissilesToTargets(obj, missilePlan)  % ����
        if  sum(sum(missilePlanReal~=missilePlanRealPer)) ~= 0  % �ҷ�����ı���
            if canChange(obj, missilePlanReal) == 0  % ���ܸ�Ŀ�꣬��ȡ��ԭ���ķ���
                missilePlanReal=missilePlanRealPer;
            else
                fprintf(file,"Change");fprintf(file,"\n");
                fprintf(file,"currentPlan=");
                fprintf(file,num2str(missilePlanReal(2,:)));fprintf(file,"\n");
                
            end
        end
    end
    % Ŀ�����
    obj.Targets.angle = obj.Targets.angle + dAng*obj.dT;
    obj = missileMoveByPNG(obj, missilePlanReal);
    obj = targetMove(obj);

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


%% �����׶�
city = zeros(obj.numOfTargets+1,2);
city(1,:) = obj.Fighters.p(1,:) + obj.Fighters.v(1)*(steps-stepFighters)*obj.dT*...
          [cos(obj.Fighters.angle(1)),sin(obj.Fighters.angle(1))]; % ����������ٶ����ػ������ƶ����ľ���
city(2:obj.numOfTargets+1,:) = obj.Targets.p;
[fTSPBest,xTSPBest] = TSPSA(city, 10000, 0.95, 0.01, 6000);
%% --------plot----------
%-------------ģ��ͼ-------------
figure1 = figure('color',[1 1 1]);
% ����legend
x = fightersSave.p(:,1,1); % ��һ���ػ�
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;
x = missilesSave.p(:,1,1);
y = missilesSave.p(:,1,2);
p2 = plot(x,y,'b');  hold on;
x = targetsSave.p(:,1,1);
y = targetsSave.p(:,1,2);
p3 = plot(x,y,'color','g');hold on;

% �ػ�
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
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
    plot(x,y,'color','g');hold on;
end
% ��ͷ
% �ػ���ʼʱ��λ�õķ���
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;
% ������ʼʱ��λ�õķ���
x = missilesSave.p(1,:,1);
y = missilesSave.p(1,:,2);
quiver(x',y', cos(missilesSave.angle(1,:))',sin(missilesSave.angle(1,:))',0.3,'color','b');
hold on;
% Ŀ���ʼʱ�̵��ٶȷ���
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;

% plot

fprintf("���·������Ϊ%f\n", fTSPBest);
P=city;N=obj.numOfTargets+1;minplan=xTSPBest;
pp1 = plot(P(1,1),P(1,2),'rp','MarkerFaceColor','r');hold on;
pp2 = plot(P(2:N,1),P(2:N,2),'r^','MarkerFaceColor','r');hold on;
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)],'color','k');
end
pp3 = line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)],'color','k');
xlabel("x/m");ylabel("y/m");
legend([p1,p2,p3,pp1,pp2,pp3],["�ػ�","����","Ŀ��","������","����","���·��"],'Location','northwest');hold on;
print(figure1,'-dpng','-r300','./png/AllProcess.png')   % ���浽����Ŀ¼��
