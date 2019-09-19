function [ ang ] = F3( x,y,p )
%   Ŀ�귽��
%   �˴���ʾ��ϸ˵��
L=5000;%Ŀ��̽�ⷶΧ
[m,~]=size(p);
ang=zeros(m,2);
d=(x-p(:,1)).^2+(y-p(:,2)).^2;
d=d.^0.5;
for i=1:m
    if d(i)<=L
        a=[x-p(i,1),y-p(i,2)];
        a=a/norm(a);
        ang(i,:)=a;
    end

end
% temp=sum(ang);
% for i=1:m
%     ang(i,:)=temp;
% end
% end

