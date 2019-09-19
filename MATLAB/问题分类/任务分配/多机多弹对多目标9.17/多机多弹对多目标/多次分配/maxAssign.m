function [ Plan ] = maxAssign( V01 )
%UNTITLED2 此处显示有关此函数的摘要
%  非平衡指派,求最大值
[numofm,numofn]=size(V01);
if numofm<numofn
    V02=[];
    V02=V01;
    V02(numofm+1:numofn,:)=zeros(numofn-numofm,numofn);
end
if numofm==numofn
   V02=V01;
end
if numofm>numofn
    V02=[];
    V02=V01;
    V02(:,numofn+1:numofm)=zeros(numofm,numofm-numofn);
end
[plan_unique,~,fout,~] = minAssign( max(max(V02))-V02,max(numofm,numofn));
plan=plan_unique(1,:);
Plan=[];
Plan(2,:)=plan(1,1:numofn);
Plan(find(Plan>numofm))=0;
Plan(1,:)=[1:numofn];
end

