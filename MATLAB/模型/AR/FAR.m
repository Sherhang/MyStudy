function [ f ] = FAR( d,Lmin )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   ���룺����d,
%   �����AR����ϵ��
a=100;b=100*Lmin;
f=a-b/d;
f=exp(d/Lmin);
end

