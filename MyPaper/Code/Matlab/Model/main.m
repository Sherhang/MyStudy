clear all;
clc;
model = MissileAndTarget(3,3,5);
model = setRand(model);
% x = get(model, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(model)
f2 =  getOptmizeMatrixOfMissileAndTarget(model)
% 载机任务计划
plan = [1 2 3 0;  2 3 1 0]; % 按照矩阵直接计算的plan
plan = decodePlanFightersToTargets(model, plan)
% 导弹任务计划
missilePlan = [1 2 3 4; 2 4 1 0];
missilePlan = decodePlanMissilesToTargets(model,missilePlan)

for i=1:1000
    if rem(i,10)==0
        oldplan = plan;
        mat =  getOptmizeMatrixOfFighterAndTarget(model);
        plan = quantumMinAssign(max(max(mat))-mat);
        plan = decodePlanFightersToTargets(model, plan); % 解码
        if plan ~= oldplan
            oldplan
            plan
        end   
    end
    model = fighterMove(model, plan);
    model = targetMove(model);
    figure(1);
    plot(model.Fighters.p(:,1), model.Fighters.p(:,2), 'g.');
    hold on;
    plot(model.Targets.p(:,1), model.Targets.p(:,2), 'b.');
end
for i=1:500
    if i==1
        mat =  getOptmizeMatrixOfMissileAndTarget(model);
        missilePlan = quantumMinAssign(max(max(mat))-mat);
        missilePlan = decodePlanMissilesToTargets(model, missilePlan) % 解码
    end
    model = missileMoveByPNG(model, missilePlan);
    model = targetMove(model);
    figure(1);
    plot(model.Missiles.p(:,1), model.Missiles.p(:,2), 'r.');
    hold on;
    plot(model.Targets.p(:,1), model.Targets.p(:,2), 'b.');
    hold on;
    %axis([0 10000 0 10000]);
end