function [ ang3] = change( ang1,ang2 )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%  ���������������ang1ԭʼ����ang2��������ang3ʵ�ʷ���
v=800;%�ٶ�
a=30*9.8;%���ٶ�
T=0.02;
w=a/v;
thetaMax=w*T;

[m,~]=size(ang1);
ang3=ang2;
for i=1:m
    a=ang1(i,:);b=ang2(i,:);
    c=acos(dot(a,b)/(norm(a)*norm(b)));
    thetaA=atan2(a(2),a(1));
    if(c>thetaMax) 
        d=thetaA+thetaMax;
        e=thetaA-thetaMax;
        b1=[cos(d),sin(d)];
        b2=[cos(e),sin(e)];
        c1=acos(dot(b,b1)/(norm(b)*norm(b1)));
        c2=acos(dot(b,b2)/(norm(b)*norm(b2)));
        if(c1<=c) ang3(i,:)=b1;
        else if c2<=c
         ang3(i,:)=b2;
            end
        end
    end
    
    
end

end

