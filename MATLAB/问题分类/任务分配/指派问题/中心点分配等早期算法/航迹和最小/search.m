flags=0;
gps(1)=gp;
s1=gp;
% gps(factorial(N))=1;
Smaxval(t)=Gmaxval(t);
for i=1:N:N*(N-1)*(N-2)*(N-3)
    gps(i+N)=gps(i)+N;
    if gps(i)>factorial(N)
        gps(i)=gps(i)-factorial(N);
    end
    clear plan;
    plan=codeVal2codeBool(c(gps(i),:),N);
    clear temp;
    temp=gains(gps(i));
    
    if temp>Smaxval(t)
        Smaxval(t)=temp;
        s1=gps(i);
        flags=flags+1;
    end
end
        
for i=1:N:N*(N-1)*(N-2)*(N-3) %反向搜索
    gps(i+N)=gps(i)-N;
    if gps(i)<1
        gps(i)=gps(i)+factorial(N);
    end
    clear plan;
    plan=codeVal2codeBool(c(gps(i),:),N);
    clear temp;
    temp=gains(gps(i));
  
    if temp>Smaxval(t)
        Smaxval(t)=temp;
         flags=flags+1;
         s1=gps(i);
    end
    
end

% for j=1:factorial(N-2):factorial(N);%跳步搜索
%     
%     gps(i+1)=gps(i)+j;
%     if gps(i)>factorial(N)
%         gps(i)=gps(i)-factorial(N);
%     end
%     clear plan;
%     plan=codeVal2codeBool(c(gps(i),:),N);
%     clear temp;
%     temp=gains(gps(i));
%     Smaxval(t)=Gmaxval(t);
%     if temp>Smaxval(t)
%         Smaxval(t)=temp;
%         s1=gps(i);
%         flags=flags+1;
%     end
% end

% gps(1)=s1;%二次搜索
% s2=s1;
% for i=1:N*N*10
%     gps(i+1)=gps(i)+1;
%     if gps(i)>factorial(N)
%         gps(i)=gps(i)-factorial(N);
%     end
%     clear plan;
%     plan=codeVal2codeBool(c(gps(i),:),N);
%     clear temp;
%     temp=sum(sum(pro.*threat.*plan));
%     Smaxval(t)=Gmaxval(t);
%     if temp>Smaxval(t)
%         Smaxval(t)=temp;
%         s2=gps(i);
%     end
% end
%         
% for i=1:N*N*10  %反向搜索
%     gps(i+1)=gps(i)-1;
%     if gps(i)<1
%         gps(i)=gps(i)+factorial(N);
%     end
%     clear plan;
%     plan=codeVal2codeBool(c(gps(i),:),N);
%     clear temp;
%     temp=sum(sum(pro.*threat.*plan));
%   
%     if temp>Smaxval(t)
%         Smaxval(t)=temp;
%         s2=gps(i);
%     end
%     
% end


    