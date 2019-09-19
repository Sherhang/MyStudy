function [ angStop] = stop( ang,x,y,p )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
L=50;%
[m,~]=size(p);
angStop=ang;
d=(x-p(:,1)).^2+(y-p(:,2)).^2;
d=d.^0.5;
for i=1:m
    if d(i)<=L
       
        angStop(i,:)=[0 0];
    end


end

