function [w] = weight( x,y,p )
%UNTITLED 变权重
%  输入目标位置x，y
% 输出各个方向的权重，每个个体权重不同
L=5000;%探测范围
[m,~]=size(p);
d=(p(:,1)-x).^2+(p(:,2)-y).^2;
d=d.^0.5;
w=zeros(m,1);
for i=1:m
   % w(i)=2*exp(d(i)/L);
   w(i)=L/(d(i));
end




end

