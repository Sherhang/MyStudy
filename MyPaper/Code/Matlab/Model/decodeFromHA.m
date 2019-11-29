% 启发式算法的解转化为虚拟目标解
% 如[2 3 5 4 1] 实际上只有4个虚拟目标[1 2 2 3]，5个虚拟导弹[1 2 3 3 4]
% 转化为[1 2 2 3 0; 2 3 5 4 0] ,然后抛弃第一行后面的0，[1 2 3 4; 2 3 5 4 ]
function x = decodeFromHA(obj, planHA)
m = obj.numOfMissiles;
n = sum(obj.targetList);
x = zeros(2,n);
x(1,:) = 1:n;
x(2,:) = planHA(1:n);
index = x(2,:)>m;
x(2,index) =0;
end