function [ angle ] = F1( x,y,p )
% ����x��1*2����������ʾλ��
%   ���һ����λ��������������
%x=0;y=1000;
%p=1000*[0 0.5;1 0;2 0];
L0=1000;
L1=1200;
L2=5000;%ͨ�ŷ�Χ




[m,n]=size(p);
d=(p(:,1)-x).^2+(p(:,2)-y).^2;
d=d.^0.5;
for i=1:m
    %f(i,:)=[0 0];
    if(d(i)~=0)  
        am=-p(i,:)+[x,y];
        am=am/d(i);
    end
    if(d(i)==0) 
        f(i,:)=[0 0];
    end
    if d(i)>0&&d(i)<L0
        f(i,:)=(L0-d(i))*am;%�ų�
    end
    if d(i)>=L0&&d(i)<=L1
        f(i,:)=[0 0];
    end
    if d(i)>L1&&d(i)<=L2
        f(i,:)=-L0/(L2-L1)*(d(i)-L1)*am;
    end
    if d(i)>L2
        f(i,:)=[0 0];
    end
%     if(abs(d(i)-d_up(i))<Lslow && a_up(1)==0&&a_up(2)==0) f(i,:)=[0 0];
%     end
end

F=sum(f);
 if(F==[0 0]) angle=[0 0];
 else
    angle=F/norm(F);
 end



end

