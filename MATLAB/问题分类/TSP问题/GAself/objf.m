function [f,p]=objf(s,dislist)
%计算所有种群的适应度 
%输入，种群，每一行是一各个体，城市距离矩阵
%输出，f适应度，每个个体的选择概率

inn=size(s,1);  %读取种群大小
d=zeros(1,inn);
for i=1:inn
   d(i)=CalDist(dislist,s(i,:));  %计算距离
end
f=1000./d.^100; %适应度函数,
%根据个体的适应度计算其被选择的概率
fsum=sum(f);
p=zeros(1,inn);
for i=1:inn
   p(i)=f(i)/fsum;
end
 
end
