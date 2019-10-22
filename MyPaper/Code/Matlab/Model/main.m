%import MissileAndTarget.*;
model = MissileAndTarget(3,2,4);
model = setRand(model);
% x = get(model, 'pTargets')

plan = [1 2 2;1 2 3];
missilePlan =[1 2 2 ; 1 2 4];
for i=1:500
    model = fighterMove(model, plan);
    model = targetMove(model);
    figure(1); 
    plot(model.Fighters.p(:,1), model.Fighters.p(:,2), 'g.');
    hold on;
    plot(model.Targets.p(:,1), model.Targets.p(:,2), 'b.');
end
for i=1:1000
    
    model = missileMoveByPNG(model, missilePlan);
    model = targetMove(model);
    figure(1);
    plot(model.Missiles.p(:,1), model.Missiles.p(:,2), 'r.');
    hold on;
    plot(model.Targets.p(:,1), model.Targets.p(:,2), 'b.');
    hold on;
    %axis([0 10000 0 10000]);
end