function [ splan] =search( Val,plan,N )
%UNTITLED7 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
temp1=nchoosek(1:N,2);
splan=plan;
Smaxval=sum(sum(Val.*codeVal2codeBool(plan,N)));
for i=1:nchoosek(N,2)
     newPlan=plan;
     newPlan([temp1(i,1) temp1(i,2) ])=plan([temp1(i,2)  temp1(i,1)]);
     temp=sum(sum(Val.*codeVal2codeBool(newPlan,N)));
     if temp>Smaxval
        Smaxval=temp;
        splan=newPlan;
     end
 end

end

