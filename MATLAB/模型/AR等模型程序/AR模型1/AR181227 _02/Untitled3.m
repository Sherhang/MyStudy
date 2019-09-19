clear;clc;
ang1=[0 1;];ang2=0.5*2^0.5*[1 1;];
v=800;%速度
a=300*9.8;%加速度
T=0.02;
w=a/v;
thetaMax=w*T;
[m,~]=size(ang1);
ang3=ang2;
for i=1:m
    a=ang1(i,:);b=ang2(i,:);
    c=acos(dot(a,b)/(norm(a)*norm(b)));
    thetaA=atan2(a(2),a(1))
    if(c>thetaMax) 
        d=thetaA+thetaMax;
        e=thetaA-thetaMax;
        b1=[cos(d),sin(d)];
        b2=[cos(e),sin(e)];
        c1=acos(dot(b,b1)/(norm(b)*norm(b1)));
        c2=acos(dot(b,b2)/(norm(b)*norm(b2)));
        if(c1<=c) ang3(i,:)=b1;
        else  
         ang3(i,:)=b2;
        end
    end
    
    
end