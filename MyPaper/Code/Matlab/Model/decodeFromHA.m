% ����ʽ�㷨�Ľ�ת��Ϊ����Ŀ���
% ��[2 3 5 4 1] ʵ����ֻ��4������Ŀ��[1 2 2 3]��5�����⵼��[1 2 3 3 4]
% ת��Ϊ[1 2 2 3 0; 2 3 5 4 0] ,Ȼ��������һ�к����0��[1 2 3 4; 2 3 5 4 ]
function x = decodeFromHA(obj, planHA)
m = obj.numOfMissiles;
n = sum(obj.targetList);
x = zeros(2,n);
x(1,:) = 1:n;
x(2,:) = planHA(1:n);
index = x(2,:)>m;
x(2,index) =0;
end