% �ػ�׷��Ŀ���˶�����,�ػ����Ӧ����̬��ռ�ŷ����˶���ֱ��׷�ٷ���
clear;
% ��ʼ����---
steps = 50000; % ����
stepStop =0 ;
step50 = 0;
dT = 0.02; % �������
T.p = 100*1000*0.7*[1 1];  % Ŀ��, ��100kmλ�ýӽ�Ŀ��
T.v = 300;
T.a = 100*pi/180;  % �����
M.p = [0 0];  % �ػ�
M.v = 400;
M.a = 30*pi/180;
GOfFighter = 30.0 * 9.8; % �ػ�������ٶ����ֵ

% λ�ü�¼

PM(1,:) = M.p;
PT(1,:) = T.p;
[fAdv(1),disAdv(1),angleAdv(1),inAngleAdv(1),speedAdv(1)] = getAdvance(M,T);
disSave(1) = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);


%% ---------ѭ����ʼ--------
for step=2:steps
    nextP = T.p;
    theta = atan2((nextP(:,2)-M.p(:,2)), nextP(:,1)-M.p(:,1));% ��λ��,��һ�ַ������÷�λ�ǵ������ֵ��
    % ����������������ٶ�����
    omiga = GOfFighter./M.v;
    maxTheta = omiga * dT; % ���ת��
    angle0Vector = [cos(M.a), sin(M.a)]; % ԭʼ����������ʽ
    angleDestVector = [cos(theta), sin(theta)];
    thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
    if(thetaAngle0WithAngleDest > maxTheta)
        d = M.a + maxTheta; % �����ķ���ֻ��������ֻҪ�Ƚ�һ�¼���
        e = M.a - maxTheta;
        dVector = [cos(d), sin(d)];
        eVector = [cos(e), sin(e)];
        % �µļн�
        dNewTheta = acos(dot(dVector, angleDestVector)/(norm(dVector)*norm(angleDestVector)));
        eNewTheta = acos(dot(eVector, angleDestVector)/(norm(eVector)*norm(angleDestVector)));
        if(dNewTheta < thetaAngle0WithAngleDest)
            theta = d;
        else
            if (eNewTheta < thetaAngle0WithAngleDest)
                theta = e;
            end
        end
    end
    
    %----�ƶ�
    % �ػ��ƶ�
    M.p = M.p+[M.v *dT.*cos(theta), M.v *dT.*sin(theta)];
    M.a = theta;
    % Ŀ���ƶ�
    T.p = T.p + [T.v *dT.*cos(T.a), T.v *dT.*sin(T.a)];
    % λ�ü�¼
    PM(step,:) = M.p;
    PT(step,:) = T.p;
    % �������
    dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
    [fAdv(step),disAdv(step),angleAdv(step),inAngleAdv(step),speedAdv(step)] = getAdvance(M,T);
    
    if dis >= 25*1000
        step50 = step;
         stepStop = step;
    end
    if dis < 25*1000 % 50*1000  % ����С��100��ֹͣ�ƶ�
        M.v = 0;
        T.v = 0;
       
        break
    end
  
end
sFighter = 400*dT*step50
%% ----------plot---------
figure1 = figure('color',[1 1 1]);
plot(PM(:,1), PM(:,2),'r-','LineWidth',1);
hold on;
plot(PT(:,1), PT(:,2), 'b-.','MarkerIndices',1:1600:step,'LineWidth',1);
% axis(1000*[0 120 0 120]);
xlabel('x/m');
ylabel('y/m');
axis([ -40*1000 80*1000 0 250*1000]);
legend('�ػ�','Ŀ��');
print(figure1,'-dpng','-r300','./png/fighterToTarget.png')   % ���浽����Ŀ¼��
%-----���ƺ���ͼ��仯
figure2 = figure('color',[1 1 1]);
plot(fAdv,'r-','MarkerIndices',1:1000:step50);hold on;
plot(disAdv,'bx-','MarkerIndices',1:1000:step50);hold on;
plot(angleAdv,'cs-','MarkerIndices',1:1000:step50); hold on;
plot(inAngleAdv,'m-^','MarkerIndices',1:1000:step50);hold on;
plot(speedAdv,'ko-','MarkerIndices',1:1000:step50); hold on;
axis([1 step50 -0.1 1.8]);
xlabel('step');
ylabel('����ֵ');
legend('̬������','��������','��λ������','���������','�ٶ�����');
print(figure2,'-dpng','-r300','./png/advance.png')   % ���浽����Ŀ¼��




%% ����������../model/fimage.m
% һ��һ���ƺ�������
function [f,disAdv, angleAdvance, inAngleAdvance, speedAdv]  = getAdvance(M,T)
% ��������
dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
disAdv = getDisAdvance(dis);
% ��λ������
a = [cos(M.a), sin(M.a)]; % �ػ���������
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % �ػ�Ŀ�����߽�����
fai = acos(max(-1,min(1,dot(a,b)/(norm(a)*norm(b))))); % ��λ��[0,pi]
angleAdvance = getAngleAdvance(fai);
% ���������
a = [cos(T.a), sin(T.a)]; % Ŀ�귽������
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % �ػ�Ŀ�����߽�����
q = acos(max(-1,min(1,dot(a,b)/(norm(a)*norm(b)))));  % �����[0,pi]
inAngleAdvance = getInAngleAdvance(q);
% �Ƕ�����
angAdv = angleAdvance*inAngleAdvance;
% �ٶ�����
speedAdv = getSpeedAdvance(M.v/T.v);

f = 0.4*disAdv + 0.3*angAdv + 0.3 *speedAdv;
end
function f = getMaxAdvance(M,T,alpha)  % ֻҪһ������ֵ��
M.a = alpha;
M.p = M.p + [M.v*cos(M.a), M.v*sin(M.a)];% ������ʱ��λ��
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
f = -f;
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