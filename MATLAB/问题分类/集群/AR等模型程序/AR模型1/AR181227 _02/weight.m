function [w] = weight( x,y,p )
%UNTITLED ��Ȩ��
%  ����Ŀ��λ��x��y
% ������������Ȩ�أ�ÿ������Ȩ�ز�ͬ
L=5000;%̽�ⷶΧ
[m,~]=size(p);
d=(p(:,1)-x).^2+(p(:,2)-y).^2;
d=d.^0.5;
w=zeros(m,1);
for i=1:m
   % w(i)=2*exp(d(i)/L);
   w(i)=L/(d(i));
end




end

