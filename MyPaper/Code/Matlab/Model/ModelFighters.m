% 载机模型，用于启发式算法的求解
% 输入：模型model，攻击决策plan，plan为基于虚拟目标的决策，如[2 3 1 4]表示[1 2 3 4; 2 3 1 4];
% 输出：一个总体优势值


function f = ModelFighters(model)


end


%% 函数部分
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
%----------总优势------
% d 距离，a 方位角，b 进入角，pv, 速度比
function f = getFighterAdvance(d,a,b,pv)  % 
f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
% 另一种方案，权重和距离有关，TODO
%f = 0.4*getDisAdvance(d) + 0.3*getAAdvance(a,b) +  0.3*getSpeedAdvance(pv);
end