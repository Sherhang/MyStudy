% һ��һ���ƺ�������



function f = getAdvance(M,T)
% ��������
dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
disAdv = getDisAdvance(dis);
% ��λ������
a = [cos(M.a), sin(M.a)]; % �ػ���������
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % �ػ�Ŀ�����߽�����
fai = acos(dot(a,b)/(norm(a)*norm(b)));  % ��λ��[0,pi]
angleAdvance = getAngleAdvance(fai);
% ���������
a = [cos(T.a), sin(T.a)]; % Ŀ�귽������
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % �ػ�Ŀ�����߽�����
q = acos(dot(a,b)/(norm(a)*norm(b)));  % �����[0,pi]
inAngleAdvance = getInAngleAdvance(q);
% �Ƕ�����
angAdv = angleAdvance*inAngleAdvance;
% �ٶ�����
speedAdv = getSpeedAdvance(M.v/T.v);

f = 0.4*disAdv + 0.3*angAdv + 0.3 *speedAdv;
end








%----------�ػ��ľ�������----------
function f = getDisAdvance(d)
%����
MaxDisOfRadar = 100*1000;     % �״������������
MaxDisOfMissile = 50*1000;    % ������󹥻�����
MinDisOfMissile = 100;         % ������С�������룬С�ڴ˾����޷����䵼��
MaxInescapableZone = 25*1000;  % �����Ĳ�����������Χ
MinInescapableZone = 15*1000;  % �����Ĳ�����������Сֵ
e = exp(1);

if d > MaxDisOfRadar          % �����״���������
    f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % �ڵ�����󹥻�������״���������֮��
    f = 1.0/e*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % �ڲ����������⣬���ڵ�������������
    f = e^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % �����������ڣ�
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % С����С���������������ڵ�����С������Χ
    f = e^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile
    f = 0;
end
end

% �ػ�or�����ķ�λ�����ƣ����뻡�ȣ��������ֵ0-1
function f = getAngleAdvance(fai)
% ����
MaxFaiOfRadar = 180/180*pi;  % �״�������λ��
MaxFaiOfMissile = 80/180*pi;  % ����������ᷢ��ǣ���������ϵͳ���ƫ��
MaxFaiOfInescapable = 40/180*pi;  % �����������������ƫ��


if fai > MaxFaiOfRadar
    f = 0;
end
if fai >= MaxFaiOfMissile && fai <= MaxFaiOfRadar
    f = 0.25*(1-(fai-MaxFaiOfMissile)/(MaxFaiOfRadar-MaxFaiOfMissile));
end
if fai >= MaxFaiOfInescapable && fai < MaxFaiOfMissile
    f = 0.75-(fai-MaxFaiOfInescapable)/2/(MaxFaiOfMissile-MaxFaiOfInescapable);
end
if fai >=0 && fai < MaxFaiOfInescapable
    f = 1-fai/4/MaxFaiOfInescapable;
end
end

%---------�ػ�or�����Ľ��������---------------
function f = getInAngleAdvance(q)
qDeg = q/pi*180;  % ����ת��Ϊ�Ƕ�
if qDeg < 45
    f = qDeg/45;
end
if qDeg >=45 && qDeg <= 180
    f = 1-(qDeg-45)/(180-45);
end
end
%-----------�Ƕ�����,��������������---------------
function f = getAAdvance(q, fai)
f = getInAngleAdvance(q)*getAngleAdvance(fai);
end

%---------�ػ�or�������ٶ�����,�����ػ��ٶ�or�����ٶȺ�Ŀ���ٶȵı�ֵ----------------
function f = getSpeedAdvance(pv)
f = 0;
if pv > 3
    f = exp((1-pv/3.0)/10);
end
if pv > 1.5 && pv <= 3
    f = 1;
end
if pv >= 0.6 && pv <= 1.5
    f = -0.5+pv;
end
if pv < 0.6
    f = 0.1;
end
end