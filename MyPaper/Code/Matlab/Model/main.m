clear all;
clc;
model = MissileAndTarget(5,6,9);
model = setRand(model);
% x = get(model, 'pTargets')
f1 = getOptmizeMatrixOfFighterAndTarget(model)
f2 =  getOptmizeMatrixOfMissileAndTarget(model)
plan = [];missilePlan = [];

for i=1:500
    if rem(i,10)==0

        mat =  getOptmizeMatrixOfFighterAndTarget(model);
        plan = quantumMinAssign(max(max(mat))-mat);
        plan = decodePlanFightersToTargets(model, plan); % ����
%         if plan ~= oldplan
%             oldplan
%             plan
%         end   
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
        missilePlan = decodePlanMissilesToTargets(model, missilePlan) % ����
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