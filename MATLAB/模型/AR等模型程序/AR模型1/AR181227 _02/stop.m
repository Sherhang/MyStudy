function [ angStop] = stop( ang,x,y,p )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

