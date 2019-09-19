function [ f ] = FAR( d,Lmin )
%UNTITLED6 此处显示有关此函数的摘要
%   输入：距离d,
%   输出：AR比例系数
a=100;b=100*Lmin;
f=a-b/d;
f=exp(d/Lmin);
end

