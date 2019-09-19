function [ plan ] = gradualMax( a,N)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
for j=1:N
    
    [row ,clo]=find(a==max(max(a)));
    Msort(j)=row(1);% 这一步是为了防止出现两个最大值，只要第一个
    Tsort(j)=clo(1);
    a(Msort(j),:)=0;
    a(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
plan=temp(:,1)';
end

