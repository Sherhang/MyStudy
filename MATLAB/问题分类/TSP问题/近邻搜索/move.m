function [ splan,SminVal] =move( Val,plan,N )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明

splan=plan;
SminVal=Val(plan(1),plan(N));
for k=1:N-1
         SminVal=SminVal+Val(plan(k),plan(k+1));
end

for i=2:N-1
     newPlan=plan;
     newPlan(i:N-1)=plan(i+1:N);
     newPlan(N)=plan(i);
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

