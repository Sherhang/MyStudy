function [ plan ] = gradualMax( a,N)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
for j=1:N
    
    [row ,clo]=find(a==max(max(a)));
    Msort(j)=row(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
    Tsort(j)=clo(1);
    a(Msort(j),:)=0;
    a(:,Tsort(j))=0;
end
temp=sortrows([Msort',Tsort'],2);
plan=temp(:,1)';
end

