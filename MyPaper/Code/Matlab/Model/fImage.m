%-------------̬�ƺ���ͼ��------------------
%--------���뺯��-----
%����
clear ;clc;
MaxDisOfRadar = 100*1000;     % �״������������
MaxDisOfMissile = 50*1000;    % ������󹥻�����
MinDisOfMissile = 100;         % ������С�������룬С�ڴ˾����޷����䵼��
MaxInescapableZone = 25*1000;  % �����Ĳ�����������Χ
MinInescapableZone = 15*1000;  % �����Ĳ�����������Сֵ
for i=1:120*1000
    x(i) = i;
    y(i) = getDisAdvance(i);
end
figure1 = figure('Color',[1 1 1]);
plot(x,y,'r');
text(MaxDisOfRadar,getDisAdvance(MaxDisOfRadar),'D_{Rmax}');   %ע��ӵ������е�ĳ��λ��
text(MaxDisOfMissile,getDisAdvance(MaxDisOfMissile),'D_{Mmax}'); 
text(MinDisOfMissile,getDisAdvance(MinDisOfMissile),'D_{Mmin}'); 
text(MaxInescapableZone,getDisAdvance(MaxInescapableZone),'D_{Imax}'); 
text(MinInescapableZone,getDisAdvance(MinInescapableZone),'D_{Imin}'); 
axis([0 120000 0 1.2]);
xlabel('����/m')
ylabel('��������ֵ')
print(figure1,'-dpng','-r300','./png/disAdvance.png')   % ���浽����Ŀ¼��
%----------��λ�Ǻ���----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getAngleAdvance(x(k));
    k = k +1;
end
figure2 = figure('Color',[1 1 1]);
plot(x*180/pi,y,'r');
xlabel('��λ��/��')
ylabel('̬������ֵ')
%----------����Ǻ���----------
clear all;
k=1;
for i = 0:0.1:pi
    x(k) = i;
    y(k) = getInAngleAdvance(x(k));
    k = k +1;
end
figure3 = figure('Color',[1 1 1]);
plot(x*180/pi,y,'r');
ylabel('�����/��')
ylabel('̬������ֵ')
%------------�Ƕ�����-----------
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
ylabel('�����/��')
xlabel('��λ��/��')
zlabel('�Ƕ�����ֵ')
print(figure5,'-dpng','-r300','./png/angAdvance.png')   % ���浽����Ŀ¼��

%----------�ٶȺ���--------
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
xlabel('�ٶȱ�'); 
ylabel('�ٶ�����');
print(figure4,'-dpng','-r300','./png/speedAdvance.png')   % ���浽����Ŀ¼��


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