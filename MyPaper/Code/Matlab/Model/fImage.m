%-------------态势函数图像------------------
%--------距离函数-----
%常量
clear ;clc;
MaxDisOfRadar = 100*1000;     % 雷达最大搜索距离
MaxDisOfMissile = 50*1000;    % 导弹最大攻击距离
MinDisOfMissile = 100;         % 导弹最小攻击距离，小于此距离无法发射导弹
MaxInescapableZone = 25*1000;  % 导弹的不可逃逸区外围
MinInescapableZone = 15*1000;  % 导弹的不可逃逸区最小值
for i=1:120*1000
    x(i) = i;
    y(i) = getDisAdvance(i);
end
figure1 = figure('Color',[1 1 1]);
plot(x,y,'r');
text(MaxDisOfRadar,getDisAdvance(MaxDisOfRadar),'D_{Rmax}');   %注解加到坐标中的某个位置
text(MaxDisOfMissile,getDisAdvance(MaxDisOfMissile),'D_{Mmax}'); 
text(MinDisOfMissile,getDisAdvance(MinDisOfMissile),'D_{Mmin}'); 
text(MaxInescapableZone,getDisAdvance(MaxInescapableZone),'D_{Imax}'); 
text(MinInescapableZone,getDisAdvance(MinInescapableZone),'D_{Imin}'); 
axis([0 120000 0 1.2]);
xlabel('距离/m')
ylabel('距离优势值')
print(figure1,'-dpng','-r300','./png/disAdvance.png')   % 保存到工作目录下
%----------方位角函数----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getAngleAdvance(x(k));
    k = k +1;
end
figure2 = figure('Color',[1 1 1]);
plot(x*180/pi,y,'r');
xlabel('方位角/°')
ylabel('态势优势值')
%----------进入角函数----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getInAngleAdvance(x(k));
    k = k +1;
end
figure3 = figure('Color',[1 1 1]);
plot(x*180/pi,y,'r');
ylabel('进入角/°')
ylabel('态势优势值')
%------------角度优势-----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    t=1;
    for j=0:0.1:pi
        x2(t) = j;
        y(k,t) = getAAdvance(x(k), x2(t));
        t = t+1;
    end
    k = k +1;
end
figure5 = figure('Color',[1 1 1]);
[x, x2]=meshgrid(0:0.1:pi,0:0.1:pi);
surf(x*180/pi,x2*180/pi,y);
ylabel('进入角/°')
xlabel('方位角/°')
zlabel('角度优势值')
print(figure5,'-dpng','-r300','./png/angAdvance.png')   % 保存到工作目录下

%----------速度函数--------
clear all;
k = 1;
for i = 0:0.01:10
    x(k) = i;
    y(k) = getSpeedAdvance(x(k));
    k = k+1;
end
figure4 = figure('Color',[1 1 1]);
plot(x,y,'r');
axis([0 10 0 1.2]);
xlabel('速度比'); 
ylabel('速度优势');
print(figure4,'-dpng','-r300','./png/speedAdvance.png')   % 保存到工作目录下


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