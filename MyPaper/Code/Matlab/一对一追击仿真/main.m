% 载机追击目标运动仿真,载机最后应该向态势占优方向运动。直接追踪法。
clear;
% 初始参数---
steps = 50000; % 步数
stepStop =0 ;
step50 = 0;
dT = 0.02; % 采样间隔
T.p = 100*1000*0.7*[1 1];  % 目标, 从100km位置接近目标
T.v = 300;
T.a = 100*pi/180;  % 航向角
M.p = [0 0];  % 载机
M.v = 400;
M.a = 30*pi/180;
GOfFighter = 30.0 * 9.8; % 载机横向加速度最大值

% 位置记录

PM(1,:) = M.p;
PT(1,:) = T.p;
[fAdv(1),disAdv(1),angleAdv(1),inAngleAdv(1),speedAdv(1)] = getAdvance(M,T);
disSave(1) = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);


%% ---------循环开始--------
for step=2:steps
    nextP = T.p;
    theta = atan2((nextP(:,2)-M.p(:,2)), nextP(:,1)-M.p(:,1));% 方位角,第一种方案是让方位角等于这个值。
    % 航向修正，满足加速度限制
    omiga = GOfFighter./M.v;
    maxTheta = omiga * dT; % 最大转向
    angle0Vector = [cos(M.a), sin(M.a)]; % 原始方向向量形式
    angleDestVector = [cos(theta), sin(theta)];
    thetaAngle0WithAngleDest = acos(dot(angle0Vector, angleDestVector)/(norm(angle0Vector)*norm(angleDestVector)));
    if(thetaAngle0WithAngleDest > maxTheta)
        d = M.a + maxTheta; % 调整的方向只有两个，只要比较一下即可
        e = M.a - maxTheta;
        dVector = [cos(d), sin(d)];
        eVector = [cos(e), sin(e)];
        % 新的夹角
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
    
    %----移动
    % 载机移动
    M.p = M.p+[M.v *dT.*cos(theta), M.v *dT.*sin(theta)];
    M.a = theta;
    % 目标移动
    T.p = T.p + [T.v *dT.*cos(T.a), T.v *dT.*sin(T.a)];
    % 位置记录
    PM(step,:) = M.p;
    PT(step,:) = T.p;
    % 计算距离
    dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
    [fAdv(step),disAdv(step),angleAdv(step),inAngleAdv(step),speedAdv(step)] = getAdvance(M,T);
    
    if dis >= 25*1000
        step50 = step;
         stepStop = step;
    end
    if dis < 25*1000 % 50*1000  % 距离小于100米停止移动
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
legend('载机','目标');
print(figure1,'-dpng','-r300','./png/fighterToTarget.png')   % 保存到工作目录下
%-----优势函数图像变化
figure2 = figure('color',[1 1 1]);
plot(fAdv,'r-','MarkerIndices',1:1000:step50);hold on;
plot(disAdv,'bx-','MarkerIndices',1:1000:step50);hold on;
plot(angleAdv,'cs-','MarkerIndices',1:1000:step50); hold on;
plot(inAngleAdv,'m-^','MarkerIndices',1:1000:step50);hold on;
plot(speedAdv,'ko-','MarkerIndices',1:1000:step50); hold on;
axis([1 step50 -0.1 1.8]);
xlabel('step');
ylabel('优势值');
legend('态势优势','距离优势','方位角优势','进入角优势','速度优势');
print(figure2,'-dpng','-r300','./png/advance.png')   % 保存到工作目录下




%% 函数，参照../model/fimage.m
% 一对一优势函数计算
function [f,disAdv, angleAdvance, inAngleAdvance, speedAdv]  = getAdvance(M,T)
% 距离优势
dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
disAdv = getDisAdvance(dis);
% 方位角优势
a = [cos(M.a), sin(M.a)]; % 载机方向向量
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % 载机目标视线角向量
fai = acos(max(-1,min(1,dot(a,b)/(norm(a)*norm(b))))); % 方位角[0,pi]
angleAdvance = getAngleAdvance(fai);
% 进入角优势
a = [cos(T.a), sin(T.a)]; % 目标方向向量
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % 载机目标视线角向量
q = acos(max(-1,min(1,dot(a,b)/(norm(a)*norm(b)))));  % 进入角[0,pi]
inAngleAdvance = getInAngleAdvance(q);
% 角度优势
angAdv = angleAdvance*inAngleAdvance;
% 速度优势
speedAdv = getSpeedAdvance(M.v/T.v);

f = 0.4*disAdv + 0.3*angAdv + 0.3 *speedAdv;
end
function f = getMaxAdvance(M,T,alpha)  % 只要一个返回值，
M.a = alpha;
M.p = M.p + [M.v*cos(M.a), M.v*sin(M.a)];% 推算下时刻位置
% 距离优势
dis = sqrt((M.p(1)-T.p(1)).^2 + (M.p(2)-T.p(2)).^2);
disAdv = getDisAdvance(dis);
% 方位角优势
a = [cos(M.a), sin(M.a)]; % 载机方向向量
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % 载机目标视线角向量
fai = acos(dot(a,b)/(norm(a)*norm(b)));  % 方位角[0,pi]
angleAdvance = getAngleAdvance(fai);
% 进入角优势
a = [cos(T.a), sin(T.a)]; % 目标方向向量
b = [T.p(1)-M.p(1), T.p(2)-M.p(2) ];   % 载机目标视线角向量
q = acos(dot(a,b)/(norm(a)*norm(b)));  % 进入角[0,pi]
inAngleAdvance = getInAngleAdvance(q);
% 角度优势
angAdv = angleAdvance*inAngleAdvance;
% 速度优势
speedAdv = getSpeedAdvance(M.v/T.v);

f = 0.4*disAdv + 0.3*angAdv + 0.3 *speedAdv;
f = -f;
end

%----------载机的距离优势----------
function f = getDisAdvance(d)
%常量
MaxDisOfRadar = 100*1000;     % 雷达最大搜索距离
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
MinDisOfMissile = 100;         % 导弹最小攻击距离，小于此距离无法发射导弹
MaxInescapableZone = 25*1000;  % 导弹的不可逃逸区外围
MinInescapableZone = 15*1000;  % 导弹的不可逃逸区最小值
e = exp(1);

if d > MaxDisOfRadar          % 大于雷达搜索距离
    f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % 在导弹最大攻击距离和雷达搜索距离之间
    f = 1.0/e*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % 在不可逃逸区外，且在导弹攻击距离内
    f = e^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % 不可逃逸区内，
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % 小于最小不可逃逸区，大于导弹最小攻击范围
    f = e^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile
    f = 0;
end
end

% 载机or导弹的方位角优势，输入弧度，输出优势值0-1
function f = getAngleAdvance(fai)
% 常量
MaxFaiOfRadar = 180/180*pi;  % 雷达搜索方位角
MaxFaiOfMissile = 80/180*pi;  % 导弹最大离轴发射角，导弹导引系统最大偏角
MaxFaiOfInescapable = 40/180*pi;  % 导弹不可逃逸区最大偏角


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

%---------载机or导弹的进入角优势---------------
function f = getInAngleAdvance(q)
qDeg = q/pi*180;  % 弧度转化为角度
if qDeg < 45
    f = qDeg/45;
end
if qDeg >=45 && qDeg <= 180
    f = 1-(qDeg-45)/(180-45);
end
end
%-----------角度优势,上面两个合起来---------------
function f = getAAdvance(q, fai)
f = getInAngleAdvance(q)*getAngleAdvance(fai);
end

%---------载机or导弹的速度优势,输入载机速度or导弹速度和目标速度的比值----------------
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