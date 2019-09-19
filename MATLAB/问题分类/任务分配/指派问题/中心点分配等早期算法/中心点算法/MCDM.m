function [ threat ] = MCDM( dis, speed, Tx,Ty,Ox,Oy,vx,vy, class )
%��׼���������
%������룬�ٶȣ��Ƕȣ�����

[m,~]=size(dis);%dis��ά����Ŀ����

%% �����Ⱥ���
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

% ��ָ���һ��
fdis1=abs(fdis/sum(fdis));
fspeed1=abs(fspeed/sum(fspeed));
ang1=abs(ang/sum(abs(ang)));
class1=class/sum(class);
%% Ȩ�ؼ���
w1=0.1;
w2=0.5;
w3=0.3;
w4=0.4;
%%
threat=w1*fdis1+w2*fspeed1+w3*ang1+w4*class1;
end



