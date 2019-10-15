%import MissileAndTarget.*;
model = MissileAndTarget(3,2,4);
model = setRand(model);
% x = get(model, 'pTargets')

plan = [1 2 2;1 2 3];
missilePlan =[1 2 2 ; 1 2 4];
for i=1:10000
    %model = fighterMove(model, plan);
    model = missileMoveByPNG(model, missilePlan);
    model = targeteMove(model);
    plot(model.Missiles.p(:,1), model.Missiles.p(:,2), 'r.');
    figure(20)
    hold on;
    plot(model.Targets.p(:,1), model.Targets.p(:,2), 'b.');
    hold on;
    %axis([0 10000 0 10000]);

end 