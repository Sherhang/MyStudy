%-------------̬�ƺ���ͼ��------------------
%--------���뺯��-----
%����
MaxDisOfRadar = 100*1000;     % �״������������
MaxDisOfMissile = 50*1000;    % ������󹥻�����
MinDisOfMissile = 10;         % ������С�������룬С�ڴ˾����޷����䵼��
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
print(figure1,'-dpng','-r300','./png/disAdvance.png')   % ���浽����Ŀ¼�£�����Ϊ"a.png"
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
title('�ػ���λ������');
xlabel('����/m')
ylabel('')
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
title('�ػ����������');
%----------�ٶȺ���--------
clear all;
k = 1;
for i = 0:0.01:2
    x(k) = i;
    y(k) = getSpeedAdvance(x(k));
    k = k+1;
end
figure4 = figure('Color',[1 1 1]);
plot(x,y,'r');
title('�ٶ�����');


%----------�ػ��ľ�������----------
function f = getDisAdvance(d)
%����
MaxDisOfRadar = 100*1000;     % �״������������
MaxDisOfMissile = 50*1000;    % ������󹥻�����
MinDisOfMissile = 10;         % ������С�������룬С�ڴ˾����޷����䵼��
MaxInescapableZone = 25*1000;  % �����Ĳ�����������Χ
MinInescapableZone = 15*1000;  % �����Ĳ�����������Сֵ

if d > MaxDisOfRadar          % �����״���������
     f = 0;
end
if d >= MaxDisOfMissile && d <= MaxDisOfRadar     % �ڵ�����󹥻�������״���������֮��
    f = 0.5*exp(-(d-MaxDisOfMissile)/(MaxDisOfRadar-MaxDisOfMissile));
end
if d >= MaxInescapableZone && d < MaxDisOfMissile % �ڲ����������⣬���ڵ�������������
    f = 2^(-(d-MaxInescapableZone)/(MaxDisOfMissile-MaxInescapableZone));
end
if d >= MinInescapableZone && d < MaxInescapableZone % �����������ڣ�
    f = 1;
end
if d >= MinDisOfMissile && d < MinInescapableZone  % С����С���������������ڵ�����С������Χ
    f = 2^(-(d- MinInescapableZone)/(MinDisOfMissile-MinInescapableZone));
end
if d < MinDisOfMissile 
    f = 0;
end
end

% �ػ�or�����ķ�λ�����ƣ����뻡�ȣ��������ֵ0-1
function f = getAngleAdvance(fai)
% ����
MaxFaiOfRadar = 90/180*pi;  % �״�������λ��
MaxFaiOfMissile = 80/180*pi;  % ����������ᷢ��ǣ���������ϵͳ���ƫ��
MaxFaiOfInescapable = 40/180*pi;  % �����������������ƫ��
 

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

%---------�ػ�or�����Ľ��������---------------
function f = getInAngleAdvance(q)
qDeg = q/pi*180;  % ����ת��Ϊ�Ƕ�
if qDeg < 50
    f = qDeg/50;
end
if qDeg >=50 && qDeg <= 180
    f = 1-(qDeg-50)/130;
end
end

%---------�ػ�or�������ٶ�����,�����ػ��ٶ�or�����ٶȺ�Ŀ���ٶȵı�ֵ----------------
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