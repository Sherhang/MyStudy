function [mplan ] = move( Val,plan,N )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
mplan=plan;
newPlan=zeros(1,N);
Mmaxval=sum(sum(Val.*codeVal2codeBool(mplan,N)));
for i=2:N
    newPlan(1:N+1-i)=plan(i:N);
    newPlan(N+2-i:N)=plan(1:i-1);
    temp=sum(sum(Val.*codeVal2codeBool(newPlan,N)));
    if temp>Mmaxval
        Mmaxval=temp;
        mplan=newPlan;
     end
 end

end

