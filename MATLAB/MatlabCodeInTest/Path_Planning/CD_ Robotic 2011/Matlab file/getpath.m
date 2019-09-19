function [A,B,LMF,NoSol,xx,yy]=getpath(map)

x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
GoalY=y(length(x));
GoalX=x(length(x));

 for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
         RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
         A1(I,J) = sum(R)+ 15*RG;
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
 end

i=1:100;
j=1:100;
A=A1;
LMF=1;
while(LMF==1)
% Searching the path
a=1;
b=1;
LMF=0;
a2=0;
b2=0;
B=zeros(length(A));
value=(abs(a-GoalX*10)+abs(b-GoalY*10));
while value>0,   %target error
[a1,b1] = checking(A,a,b,100,100);
if((a1==a)&(b1==b))    %Local min or target
a=a1;
b=b1;
B(a,b)=w(length(w));
LMF=0;
break;
else
    if(a1==a2) & (b1==b2)   %Local min exist
        LMF=1;
        A(a1,b1)=300;
       % B(a1,b1)=0;
        break;
    end
a2=a;
b2=b;
a=a1;
b=b1;
B(a,b)=w(length(w));
end
value=(abs(a-GoalX*10)+abs(b-GoalY*10));
end

% if(LMF==1)
%     display('Local Minimum exists')
% end
end

xx=[];
yy=[];
for ii=1:100
    for jj=1:100
        if B(ii,jj)~=0
            xx=[xx ii];
            yy=[yy jj];
        end
    end
end

NoSol=0;
for ii=1:100
    for jj=1:100
        if (B(ii,jj)==w(length(w)))
            if (A1(ii,jj)==300)
                NoSol=1;
            end
        end
    end
end

return
