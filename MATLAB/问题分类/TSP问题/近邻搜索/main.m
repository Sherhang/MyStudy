clear;
clc;
P=[54, 67
54, 62
37, 84
41, 94
 2, 99
 7, 64
25, 62
22, 60
18, 54
 4, 50
13, 40
18, 40
24, 42
25, 38
44, 35
41, 26
45, 21
58, 35
62, 32
82,  7
91, 38
83, 46
71, 44
64, 60
68, 58
83, 69
87, 76
74, 78
71, 71
58, 69];%******oliver30数据，最小值是423.741
N=30;
flag2=0;flag1=0;
for i=1:N
    for j=1:N
       D(i,j)=sqrt((P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2);
    end
end

for i=1:N^2
    splan(i,:)=randperm(N);
    choosePlan=splan(i,:);
        while 1
            
            [choosePlan,S]=search( D,choosePlan,N );
          %  [choosePlan,S]=move( D,choosePlan,N );
            Smin(i)=S;

            if splan(i,:)==choosePlan 
                flag1=flag1+1;
                break
            end
            splan(i,:)=choosePlan;
            flag2=flag2+1;
        end
        
       
        
end
Sminval=min(Smin)
place=find(Smin==Sminval);
minplan=splan(i,:)

figure(1)
plot(P(:,1),P(:,2),'ro');
hold on
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)]);
end
 line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)]);
 
 figure(2)
 plot(Smin,'bo');
 hold on
 plot(place,Smin(place),'r*');


