function [ splan,SminVal] =search( Val,plan,N )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
temp1=nchoosek(1:N,2);
splan=plan;
SminVal=Val(plan(1),plan(N));
for k=1:N-1
         SminVal=SminVal+Val(plan(k),plan(k+1));
end

for i=1:nchoosek(N,2)
     newPlan=plan;
     newPlan([temp1(i,1) temp1(i,2) ])=plan([temp1(i,2)  temp1(i,1)]);
     S=Val(newPlan(1),newPlan(N));
     for k=1:N-1
         S=S+Val(newPlan(k),newPlan(k+1));
     end
     
     
     
     if S<SminVal
        SminVal=S;
        splan=newPlan;
     end
 end

end

