
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
x0=Pt(1);y0=Pt(2);
r=5000;
theta=0:pi/50:2*pi;
x=x0+r*cos(theta);
y=y0+r*sin(theta);

plot(x,y,'y-',x0,y0,'r.');




