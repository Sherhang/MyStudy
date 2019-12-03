% 穷举法求精确解(Exhaustive Attack method)
tic;
N = max(obj.numOfMissiles, sum(obj.targetList));
allPerms = perms(1:N);
numOfAll = size(allPerms,1);
fEAM = zeros(numOfAll,1);
for i=1:numOfAll
    plan = decodeFromHA(obj,allPerms(i,:));
    fEAM(i) =  ModelFighters(obj, plan);
end
plot(fEAM,'o');
[maxF,maxIndex] = max(fEAM)
bessEAMPlan = allPerms(maxIndex,:);
clear allPerms;
toc