% �ػ�ģ�ͣ���������ʽ�㷨�����
% ���룺ģ��model����������plan0��planΪ��������Ŀ��ľ��ߣ���[1 2 3 4; 2 3 1 0];
%                       ������max(��������������Ŀ��������
% �����һ����������ֵ
function f = ModelFighters(obj, plan)
[M, T] = getOptmizeMatrixOfFighterAndTarget(obj) ;% ���������ػ������ƺ�������,T����ʱ�����
%------���㺯��ֵ------
% ͳ��ʵ������plan�ڶ��з�0����
N = sum(plan(2,:)~=0);T = zeros(1,N);
f1 = 0; k=1;
for i=1:size(plan,2)
    p=plan(2,i);q=plan(1,i);   % ������
    if  p~=0   % ��һ��Ϊ0��ʾ������
        % ��һ��
        f1 = f1 + M(p,q);
        % ʱ�����
        T(k) = obj.FTime(p,q); k = k+1;
    end
end
% ʱ�����


f2 = std(T);% ʱ��ı�׼�һ����ʵ�����ݷ�Χ��1/4
f3 = max(T);% ʱ������ֵ
f = 0.5*f1/N + 0.2*(1- f2/obj.Tmax)+0.3*(1 - f3/obj.Tmax);% TODO ����Ȩ������ȷ������ΰ�f2,f3�任��0-1��
end


