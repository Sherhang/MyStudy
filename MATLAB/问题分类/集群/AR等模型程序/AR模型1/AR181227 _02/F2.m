function [ ang ] = F2( P,ang1 )
% ����λ��m*2����
%   ����������һ���Է���
L3up=1500;%һ�������þ���
L3down=0;
[m,~]=size(P);
for i=1:m
    for j=1:m
        D(i,j)=(P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2;
        D(i,j)=sqrt(D(i,j));
    end
end

ang=ang1;
%���巽���������������ang1����ĺͣ�ang1ȡԭʼ����/ԭʼ����AD�ϳ�
for i=1:m
    for j=1:m
      if D(i,j)<=L3up&&i~=j&&D(i,j)>L3down
          ang(i,:)=ang(i,:)+ang1(j,:);
      end

    end
end
%��λ��
for i=1:m
    if(ang(i,:)~=[0 0]) 
        ang(i,:)=ang(i,:)/norm(ang(i,:));
    end
end

