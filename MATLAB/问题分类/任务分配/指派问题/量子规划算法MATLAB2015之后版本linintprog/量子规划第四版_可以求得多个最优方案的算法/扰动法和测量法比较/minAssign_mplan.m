function [ Qplan_unique,EQplan,f1,f2] = minAssign_mplan( Val,M)
%UNTITLED 此处显示有关此函数的摘要
%  Val最小化问题系数矩阵，M扰动测量次数，M为希望得到的最优方案数目的最大值
 % Qplan_unique不重复最优方案,Qmaxval测量中方案的总体函数值,f方案对应函数值
 [~,N]=size(Val);
 %q=mean(mean(Val))/10^4;%干扰量级，设置为待求数的小4级
 q=0.000001;%干扰量级，设置为待求数的小5级
 
for i=1:M  %干扰次数 
   [Qplan,EQplan]=minAssign_noise(Val+q*rand(N,N));
    Qplan_store(i,:)=Qplan;
    Qminval(i)=sum(sum(Val.*codeVal2codeBool(Qplan,N)));%实际计算以输入来算法，不可再加噪声，实际上加噪声也没什么影响    
end
Qplan_unique=unique(Qplan_store,'rows');
f1=min(Qminval);
f2=max(Qminval);

end

