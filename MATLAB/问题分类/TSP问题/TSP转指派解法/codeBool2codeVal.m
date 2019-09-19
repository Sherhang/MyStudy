function [ row ] = codeBool2codeVal( plan,N )
%UNTITLED3 01编码转实值编码
%   此处显示详细说明
[row,~,~]=find(plan==1);
row=row';
end

