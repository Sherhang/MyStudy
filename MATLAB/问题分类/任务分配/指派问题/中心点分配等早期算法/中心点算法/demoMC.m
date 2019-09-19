
%多准则决策理论
%输入距离，速度，角度，类型

T=50;
dis=Tdis(:,T);
speed=sqrt(Tvx.^2+Tvy.^2);
Tx=Tpx(:,T);
Ty=Tpy(:,T);
Ox=Ox(:,T);
Oy=Oy(:,T);
vx=Tvx;
vy=Tvy;
class=[1 1 1 1 1 1 1 1]';
[m,~]=size(dis);%dis的维数，目标数

%% 隶属度函数
%*******dis****%
for t=1:m
    if dis(t)<500000
        fdis(t)=1-0.9*dis(t)/500000;
    else
        fdis(t)=1;
    end
end
fdis=fdis'; 
%*******speed****%
speed=abs(speed);
for t=1:m
    if speed(t)<1000
        fspeed(t)=speed(t)/1000;
    else
        fspeed(t)=1;
    end
end
fspeed=fspeed';
%************angle*********%
x=Ox-Tx;
y=Oy-Ty;
for t=1:m
  a=[x(t) y(t)];
  b=[vx(t) vy(t)];
  ang(t)=acos(dot(a,b)/(norm(a)*norm(b)));
end
ang=ang';

% 各指标归一化
fdis1=abs(fdis/sum(fdis));
fspeed1=abs(fspeed/sum(fspeed));
ang1=abs(ang/sum(abs(ang)));
class1=class/sum(class);
%% 权重计算
w1=0.5;
w2=0.3;
w3=0.2
w4=0.1
%%
threat=w1*fdis1+w2*fspeed1+w3*ang1+w4*class1;