
%位置优势函数图像
clear;
clc;

DRmax=1000;%雷达最大搜索距离
DMmax=500;%导弹最大攻击距离
Dmin=1;%导弹最小攻击距离
DMKmax=300;%导弹最大不可逃逸区
DMKmin=100;%最小不可逃逸区
j=1;
D=[1:1000]';
m=size(D,1)
for i=1:m
 
        if (D(i,j)>=DRmax||D(i,j)<10)
            Vp(i,j)=0;
        end
        if (D(i,j)>=DMmax&&D(i,j)<DRmax)
            Vp(i,j)=0.5*exp(-(D(i,j)-DMmax)/(DRmax-DMmax));
        end
        if (D(i,j)>=DMKmax&&D(i,j)<DMmax)
            Vp(i,j)=2^(-(D(i,j)-DMKmax)/(DMmax-DMKmax));
        end
        if (D(i,j)>=DMKmin&&D(i,j)<DMKmax)
            Vp(i,j)=1;
        end
        if (D(i,j)>=10&&D(i,j)<DMKmin)
            Vp(i,j)=2^(-(D(i,j)-DMKmin)/(10-DMKmin));
        end
 
end
plot(Vp)