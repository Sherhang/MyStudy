clear all;
clc;
model = MissileAndTarget(1,1,1);
model = setRand(model);
% x = get(model, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(model)
f2 =  getOptmizeMatrixOfMissileAndTarget(model)
plan = [];missilePlan = [];

%-----位置保存-------
% 迭代次数
stepFighters = 600;
stepMissiles = 500;
steps = stepFighters+stepMissiles;
fightersSave.p = zeros(steps,model.numOfFighters,2);
fightersSave.p(1,:,:) = model.Fighters.p;
targetsSave.p = zeros(steps,model.numOfTargets,2);
targetsSave.p(1,:,:) = model.Targets.p;

for i=1:stepFighters
    f1 = getOptmizeMatrixOfFighterAndTarget(model);
    meanF1(i) = mean(mean(f1));
    if i==1    %rem(i,10)==0  % rem%10 == 0
        mat =  getOptmizeMatrixOfFighterAndTarget(model);
        plan = quantumMinAssign(max(max(mat))-mat);
        plan = decodePlanFightersToTargets(model, plan); % 解码
        %         if plan ~= oldplan
        %             oldplan
        %             plan
        %         end
    end
    model = fighterMove(model, plan);
    model = targetMove(model);
    fightersSave.p(i,:,:) = model.Fighters.p;
    targetsSave.p(i,:,:) = model.Targets.p;
    figure(1);
    plot(model.Fighters.p(:,1), model.Fighters.p(:,2), 'b.');
    hold on;
    plot(model.Targets.p(:, 1), model.Targets.p(:,2), 'g.');
end

meanF2 = zeros(steps,1);
for i=stepFighters+1:stepMissiles
    f2 =  getOptmizeMatrixOfMissileAndTarget(model);
    meanF2(i) = mean(mean(f2));
    if i==601
        mat =  getOptmizeMatrixOfMissileAndTarget(model);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlan = decodePlanMissilesToTargets(model, missilePlan) % 解码
    end
    model = missileMoveByPNG(model, missilePlan);
    model = targetMove(model);
%     figure(1);
%     plot(model.Missiles.p(:,1), model.Missiles.p(:,2), 'r.');
%     hold on;
%     plot(model.Targets.p(:,1), model.Targets.p(:,2), 'g.');
%     hold on;
    %axis([0 10000 0 10000]);
end

%---------plot----------
figure5 = figure('color',[1 1 1]);
for i=1:model.numOfFighters
    plot(fightersSave.p(:,i,1), fightersSave.p(:,i,2));
end

figure(2);
plot(meanF1,'r');
hold on;
plot(meanF2,'b')