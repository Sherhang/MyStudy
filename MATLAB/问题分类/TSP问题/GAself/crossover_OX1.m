% �������OX1
% ���룬�����⣬��s1=[1 2 3 4], s2=[2 4 3 1],�����������λ����2 4
% ����������µĽ⣬child1=[ 4     2     3     1],child2 =  [2     1     3     4]
function [child1,child2]=crossover_OX1(s1,s2)
numLimit=size(s1,2);
scro = [s1;s2];
r = randperm(numLimit,2); %��[1,numLimit]��Χ���������2������λ
chb1=min(r);
chb2=max(r);
chb1=3;
chb2=5;
middle=scro(1,chb1+1:chb2);
scro(1,chb1+1:chb2)=scro(2,chb1+1:chb2);
scro(2,chb1+1:chb2)=middle;
for i=1:chb1 %�ƺ�������
    while find(scro(1,chb1+1:chb2)==scro(1,i))
        zhi=find(scro(1,chb1+1:chb2)==scro(1,i));
        y=scro(2,chb1+zhi);
        scro(1,i)=y;
    end
    while find(scro(2,chb1+1:chb2)==scro(2,i))
        zhi=find(scro(2,chb1+1:chb2)==scro(2,i));
        y=scro(1,chb1+zhi);
        scro(2,i)=y;
    end
end
for i=chb2+1:numLimit
    while find(scro(1,1:chb2)==scro(1,i))
        zhi=logical(scro(1,1:chb2)==scro(1,i));
        y=scro(2,zhi);
        scro(1,i)=y;
    end
    while find(scro(2,1:chb2)==scro(2,i))
        zhi=logical(scro(2,1:chb2)==scro(2,i));
        y=scro(1,zhi);
        scro(2,i)=y;
    end
end
child1 = scro(1,:);
child2 = scro(2,:);

end
