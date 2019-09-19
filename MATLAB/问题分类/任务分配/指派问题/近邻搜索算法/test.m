mplan=plan;
Mmaxval=sum(sum(Val.*codeVal2codeBool(mplan,N)));
for i=2:N
     newPlan(1:N+1-i)=plan(i:N);
    newPlan(N+2-i:N)=plan(1:i-1)
    temp=sum(sum(Val.*codeVal2codeBool(newPlan,N)));
    if temp>Mmaxval
        Mmaxval=temp;
        mplan=newPlan;
     end
 end