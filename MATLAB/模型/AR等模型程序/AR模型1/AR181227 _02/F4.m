function [ ang4 ] = F4( x,y,p )
%UNTITLED6 额外吸引因子
%   只对没有发现目标的个体有效
L=5000;%目标探测范围
Lc=10000;%通信
[m,~]=size(p);
ang=zeros(m,2);
d=(x-p(:,1)).^2+(y-p(:,2)).^2;
d=d.^0.5;
findT=false(m,1);
ang4=zeros(m,2);
for i=1:m
    for j=1:m
        D(i,j)=(p(i,1)-p(j,1))^2+(p(i,2)-p(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end
for i=1:m
    if d(i)<L findT(i)=true;
    end
end
for i=1:m
    for j=1:m
      if findT(j)&&(~findT(i))&&D(i,j)<Lc
        ang4(i,:)=ang4(i,:)+[p(j,1)-p(i,1),p(j,2)-p(i,2)];
      end
    end
end

for i=1:m
    if(ang4(i,:)~=[0 0]) 
        ang4(i,:)=ang4(i,:)/norm(ang4(i,:));
    end
end
    
end

