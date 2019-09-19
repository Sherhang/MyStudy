for i=2:popsize %更新速度
    for j=31:45
        pop(i,j)=rand()*pop(i-1,j)+c1*rand()*(pop(i-1,j-15)-pop(i-1,j-30))+ c2*rand()*(gbest(j-30) -pop (i -1,j-30));
        if pop(i,j)>max_velocity
            pop(i,j)=max_velocity;
        end
        if pop(i,j)<0
                pop(i,j)=0;
        end
    end
% pop(i,9)=rand()*pop(i-1,9)+c1*rand()*(pop(i-1,5)-pop(i-1,1))+ c2*rand()*(gbest_x (1) -pop (i -1,1)); 
% pop (i,10) =rand ()*pop (i -1,10)+c1*rand()*(pop(i-1,6)-pop(i-1,2))+c2*rand()*(gbest_y(1) -pop (i -1,2)); 
% pop (i,11) =rand ()*pop (i -1,11) +c1*rand ()*(pop (i -1,7) -pop (i -1,3)) +c2*rand ()* (gbest_z (1) -pop (i -1,3));
% pop (i,12) =rand ()*pop (i -1,12) +c1*rand ()* (pop (i -1,8) -pop (i -1,3))+c2*rand()*(gbest_w(1)-pop(i-1,4));
end
%更新粒子位置
for i=2:popsize
    for j=1:15
        pop(i,j)=pop(i-1,j)+pop(i,j+30);
    end
% pop(i,1)=pop(i-1,1)+pop(i,9);
% pop(i,2)=pop(i-1,2)+pop(i,10);
% pop(i,3)=pop(i-1,3)+pop(i,11);
% pop(i,4)=pop(i-1,4)+pop(i,12);
end
for i=1:popsize
    for j=1:15
        pop(i,j)=abs(fix(pop(i,j)));
    end
% pop(i,1)=floor(pop(i,1)); 
% pop(i,2)=floor(pop(i,2));
% pop(i,3)=floor(pop(i,3));
% pop(i,4)=floor(pop(i,4));
    for j=1:15
    
        if abs(pop(i,j))>8
            pop(i,j)=randpop(8);
        end
        if abs(pop(i,j))<1
            pop(i,j)=1;
        end
    end
end

