%********实际搜索模式，因为解空间未知，只能通过变换最初解来搜索****%
%******搜索一阶邻近点N(N-1)/2个
 clear temp1;
 flags=0;
 temp1=nchoosek(1:N,2);
 Smaxval(t)=Gmaxval(t);
 gps(1)=gp;%当前方案
 s1=gp;

 for i=1:nchoosek(N,2)
     SearchPlan=Gplan;
     SearchPlan([temp1(i,1) temp1(i,2) ])=Gplan([temp1(i,2)  temp1(i,1)]);
     
     clear plan;
     plan=codeVal2codeBool(SearchPlan,N);
     clear temp;
     temp=sum(sum(pro.*threat.*plan));
     if temp>Smaxval(t)
        Smaxval(t)=temp;
        [~,s1,~]=intersect(c,SearchPlan,'rows') ;
        flags=flags+1;
     end
 end
