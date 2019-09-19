function [ ang ] = F2( P,ang1 )
% 输入位置m*2向量
%   输出各个体的一致性方向
L3up=1500;%一致性作用距离
L3down=0;
[m,~]=size(P);
for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end

ang=ang1;
%个体方向等于邻域内所有ang1方向的和，ang1取原始方向/原始方与AD合成
for i=1:m
    for j=1:m
      if D(i,j)<=L3up&&i~=j&&D(i,j)>L3down
          ang(i,:)=ang(i,:)+ang1(j,:);
      end

    end
end
%单位化
for i=1:m
    if(ang(i,:)~=[0 0]) 
        ang(i,:)=ang(i,:)/norm(ang(i,:));
    end
end

