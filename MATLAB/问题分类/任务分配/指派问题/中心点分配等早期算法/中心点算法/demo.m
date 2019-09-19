clear;
clc;
ax=[10 5 8]';
ay=[1 4 9]';
ox=[2 6 9]';
oy=[3 8 6]';
[P,st]=sort(ax,'descend')
as=sqrt((ax-ox).^2+(ay-oy).^2)
[A,b]=sort(as,'descend')