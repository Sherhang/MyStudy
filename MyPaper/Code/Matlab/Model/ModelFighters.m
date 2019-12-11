% 载机模型，用于启发式算法的求解
% 输入：模型model，攻击决策plan0，plan为基于虚拟目标的决策，如[1 2 3 4; 2 3 1 0];
%                       长度是max(导弹数量，虚拟目标数量）
% 输出：一个总体优势值
function f = ModelFighters(obj, plan)
[M, T] = getOptmizeMatrixOfFighterAndTarget(obj) ;% 加入虚拟载机的优势函数矩阵,T估算时间矩阵
%------计算函数值------
% 统计实际任务，plan第二行非0个数
N = sum(plan(2,:)~=0);T = zeros(1,N);
f1 = 0; k=1;
for i=1:size(plan,2)
    p=plan(2,i);q=plan(1,i);   % 虚拟编号
    if  p~=0   % 有一个为0表示不攻击
        % 第一项
        f1 = f1 + M(p,q);
        % 时间矩阵
        T(k) = obj.FTime(p,q); k = k+1;
    end
end
% 时间矩阵


f2 = std(T);% 时间的标准差，一般是实际数据范围的1/4
f3 = max(T);% 时间的最大值
f = 0.5*f1/N + 0.2*(1- f2/obj.Tmax)+0.3*(1 - f3/obj.Tmax);% TODO 这里权重难以确定，如何把f2,f3变换到0-1？
end


