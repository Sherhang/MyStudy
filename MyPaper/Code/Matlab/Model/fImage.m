%-------------态势函数图像------------------
%--------距离函数-----
for i=1:120*1000
    x(i) = i;
    y(i) = getDisAdvance(i);
end
figure(1);
plot(x,y,'r');
title('载机的距离优势');
%----------方位角函数----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getAngleAdvance(x(k));
    k = k +1;
end
figure(2);
plot(x*180/pi,y,'r');
title('载机方位角优势');

%----------进入角函数----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getInAngleAdvance(x(k));
    k = k +1;
end
figure(3);
plot(x*180/pi,y,'r');
title('载机进入角优势');
%----------速度函数--------
clear all;
k = 1;
for i = 0:0.01:2
    x(k) = i;
    y(k) = getSpeedAdvance(x(k));
    k = k+1;
end
figure(4);
plot(x,y,'r');
title('速度优势');


%----------载机的距离优势----------
function f = getDisAdvance(d)
%常量
MaxDisOfRadar = 100*1000;     % 雷达最大搜索距离
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
MinDisOfMissile = 10;         % 导弹最小攻击距离，小于此距离无法发射导弹
MaxInescapableZone = 5*1000;  % 导弹的不可逃逸区外围
MinInescapableZone = 2*1000;  % 导弹的不可逃逸区最小值

if d > MaxDisOfRadar          % 大于雷达搜索距离
     f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % 在导弹最大攻击距离和雷达搜索距离之间
    f = 0.5*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % 在不可逃逸区外，且在导弹攻击距离内
    f = 2^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % 不可逃逸区内，
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % 小于最小不可逃逸区，大于导弹最小攻击范围
    f = 2^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile 
    f = 0;
end
end

% 载机or导弹的方位角优势，输入弧度，输出优势值0-1
function f = getAngleAdvance(fai)
% 常量
MaxFaiOfRadar = 90/180*pi;  % 雷达搜索方位角
MaxFaiOfMissile = 80/180*pi;  % 导弹最大离轴发射角，导弹导引系统最大偏角
MaxFaiOfInescapable = 40/180*pi;  % 导弹不可逃逸区最大偏角
 

if fai > MaxFaiOfRadar
    f = 0;
end
if fai >= MaxFaiOfMissile && fai <= MaxFaiOfRadar
    f = 0.3*(1-(fai-MaxFaiOfMissile)/(MaxFaiOfRadar-MaxFaiOfMissile));
end
if fai >= MaxFaiOfInescapable && fai < MaxFaiOfMissile
    f = 0.8-(fai-MaxFaiOfInescapable)/2/(MaxFaiOfMissile-MaxFaiOfInescapable);
end
if fai >=0 && fai < MaxFaiOfInescapable
    f = 1-fai/5/MaxFaiOfInescapable;
end
end

%---------载机or导弹的进入角优势---------------
function f = getInAngleAdvance(q)
qDeg = q/pi*180;  % 弧度转化为角度
if qDeg < 50
    f = qDeg/50;
end
if qDeg >=50 && qDeg <= 180
    f = 1-(qDeg-50)/130;
end
end

%---------载机or导弹的速度优势,输入载机速度or导弹速度和目标速度的比值----------------
function f = getSpeedAdvance(pv)
if pv > 1.5
    f = 1;
end
if pv >= 0.6 && pv <= 1.5
    f = -0.5+pv;
end
if pv < 0.6
    f = 0.1;
end
end