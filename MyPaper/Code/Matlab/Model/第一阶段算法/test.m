%% �������Ӳ���
s1 = 1:8;
s2 = [2 4 6 8 7 5 3 1];
% OX1
[c1 ,c2] = crossOX1(s1,s2);
[c1 ,c2] = crossOX2(s1,s2);
s1 = 1:9;
s2 = [5 4 6 9 2 3 7 8 1];
[c1 ,c2] = crossCX(s1,s2);
s2 =[5 4 6 3 1 9 2 7 8];
[c1,c2] = crossPBX(s1, s2)



% �������Ӳ���
%% PMX���淨�����������⣬���������½�
function [child1,child2]=crossPMX(s1,s2)
% ����������s1,s2,��������Ľ�
% s1 = [1 2 3 4 5 6 7 8],s2=[2 4 6 8 7 5 3 1]
% �����ѡ4 6
% child1 =[1     2     3     8     7     5     6     4]
% child2 = [2     8     7     4     5     6     3     1]
bn=size(s1,2);
scro(1,:)=s1;
scro(2,:)=s2;
r = randperm(bn,2); %��[1,bn]��Χ���������2������λ
chb1=min(r); % ����ѡ���λ����[chb1+1 : chb2]
chb2=max(r);
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
for i=chb2+1:bn
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
child1=scro(1,:);
child2=scro(2,:);
end
%% ��һ��ʵ��cross_PMX ����ƥ�䷨,ԭ�㷨��ȱ�ݣ�Ŀǰ�Ѿ�ȥ���˿���������Ľ�
function [child1,child2] = cross_PMX(P1, P2)

numLimit = size(P1,2);
child1=zeros(1,size(P1,2));
child2=zeros(1,size(P1,2));
for k=1:numLimit  %replace 10 and increase number if here infinity if problem d=0;
    fC1=find(P2);
    for i=1:numLimit  %%replace 10 and increase number if here infinity if problem with r1==r2
        r=randi([2,size(P2,2)-1],1,2); % ������������û���
        lo=min(r);
        up=max(r);
        if lo==up
            continue
        else
            break
        end
    end
    for i=lo:up
        child1(i)=P2(fC1(i));
    end
    for i= lo:up
        a=P1(i);%2
        b=child1(i);%5
        G=find(a==child1);
        if isempty(G)&& a~=b
            Z=find(b==P1);
            if child1(Z)==0
                child1(Z)=a;
            else
                t=P2(Z);%7
                Z=find(t==P1);%3
                child1(Z)=a;
            end
        end
    end
    d=find(child1==0);%here deal with matrix size and also embed if the position is already occupied.....
    if (d==0)
        continue
    else
        break
    end
end
for i=1:size(d,2)
    child1(d(i))=P1(d(i));
end
fC2=find(P1);
for k=1:numLimit
    for i=lo:up
        child2(i)=P1(fC2(i));
    end
    for i= lo:up;
        a=P2(i);%7
        b=child2(i);%5
        G=find(a==child2);
        if isempty(G)&& a~=b
            Z=find(b==P2);
            if child2(Z)==0;
                child2(Z)=a;
            else
                t=P1(Z);%7
                Z=find(t==P2);%3
                child2(Z)=a;
            end
        end
    end
    d=find(child2==0);%here deal with matrix size and also embed if the position is already occupied.....
    if (d==0)
        continue
    else
        break
    end
end
for i=1:size(d,2)
    child2(d(i))=P2(d(i));
end
% ���º�����Ϊ�˷�ֹPMX�㷨����������Ҫ��Ľ�
tmp = 1:numLimit;
if (sum(sort(child1)==tmp)~=numLimit) || (sum(sort(child2)==tmp)~=numLimit)
        child1 = P2;child2=P1;
end
end
%% crossOX1 ���򽻲淨
function [child1,child2]=crossOX1(s1,s2)
% �������OX1
% ���룬�����⣬��s1=[1 2 3 4], s2=[2 4 3 1],�����������λ����2 4,�򽻻�����2+1=3:4
% ����������µĽ⣬child1=[ 4 2 3 1],child2 =  [2 1 3 4]
numLimit=length(s1);
r = randperm(numLimit,2); %��[1,numLimit]��Χ���������2������λ
chb1=min(r);
chb2=max(r);
% chb1=2;  % DEBUG
% chb2=5;
% ����ѡ�е�Ƭ��,����ʣ�µĿ��Բ����ǣ�ֱ��ȫ��
child1 = s2;
child2 = s1;
% ��ʣ��Ĳ���
c1Left = setdiff(s1, s2(chb1+1:chb2),'stable'); % stable����s1��˳�򷵻أ����������
c2Left = setdiff(s2, s1(chb1+1:chb2),'stable'); % 
% ���ʣ�ಿ��,�Ӻ��濪ʼ��䣬���Ǻ�OX1��ͬ�ĵط�
child1(chb2+1:numLimit) = c1Left(1:numLimit-chb2);
child1(1:chb1) = c1Left(length(c1Left)-chb1+1  :length(c1Left));
child2(chb2+1:numLimit) = c2Left(1:numLimit-chb2);
child2(1:chb1) = c2Left(length(c1Left)-chb1+1  :length(c1Left));
end
%% crossOX2 ���򽻲淨
function [child1,child2]=crossOX2(s1,s2)
% �������OX2
% ���룬�����⣬��s1=[1 2 3 4], s2=[2 4 3 1],�����������λ����2 4,�򽻻�����2+1=3:4
% ����������µĽ⣬child1=[ 4 2 3 1],child2 =  [2 1 3 4]
numLimit=length(s1);
r = randperm(numLimit,2); %��[1,numLimit]��Χ���������2������λ
chb1=min(r);
chb2=max(r);
% chb1=2;  % DEBUG
% chb2=5;
% ����ѡ�е�Ƭ��,����ʣ�µĿ��Բ����ǣ�ֱ��ȫ��
child1 = s2;
child2 = s1;
% ��ʣ��Ĳ���
c1Left = setdiff(s1, s2(chb1+1:chb2),'stable'); % stable����s1��˳�򷵻أ����������
c2Left = setdiff(s2, s1(chb1+1:chb2),'stable'); % 
% ���ʣ�ಿ��
child1(1:chb1) = c1Left(1:chb1);
child1(chb2+1:numLimit) = c1Left(chb1+1:length(c1Left));
child2(1:chb1) = c2Left(1:chb1);
child2(chb2+1:numLimit) = c2Left(chb1+1:length(c1Left));
end
%% ѭ�����淨
function [child1, child2] = crossCX(s1,s2)
numLimit = length(s1);
% ��һ������һ������Ϊ�±�����
p = randperm(numLimit,1) % ���ѡһ��λ��
% p = 1; % DEBUG
start = s1(p); % ��ʼ�ĵ�
loop = []; % �������
k = 1;
loop(k) = p; % ��ʼ��
while s2(p)~=start && k<numLimit
    k = k+1;
    p = find(s1==s2(p)); % ��һ��λ��
    loop(k) = p;
end
leftP = setdiff([1:numLimit],loop,'stable'); % �ǻ���λ��
child1 = s1;
child1(leftP) = s2(leftP);
child2 = s2;
child2(leftP) = s1(leftP);
end
%% ����λ�õĽ��淨
function [child1, child2] = crossPBX(s1,s2)
numLimit = length(s1);
% ��һ�������ѡȡ�����λ��
num = randperm(numLimit,1);
pChoose = sort(randperm(numLimit, num)); % ���ѡ�����λ��
% pChoose = [2 5 6 9]; %DEBUG
pNChoose = setdiff(1:numLimit, pChoose, 'stable'); % û�б�ѡ�е�λ��

sPut1 = setdiff(s2,s1(pChoose),'stable'); % �ҵ�s2��Ԫ��-s1�б�ѡ�е�Ԫ��
child1 = s1;
child1(pNChoose) = sPut1;

sPut2 = setdiff(s1,s2(pChoose),'stable'); % �ҵ�s2��Ԫ��-s1�б�ѡ�е�Ԫ��
child2 = s2;
child2(pNChoose) = sPut2;

end
% ��������
%% �������� EM, 
function s2 = mutateEM(s1)
numLimit = size(s1,2);
p= randperm(numLimit,2);
s2 = s1;
s2(p(1)) = s1(p(2));
s2(p(2)) = s1(p(1));
end 
%% �滻���� DM
function s2 = mutateDM(s1)
% ����һ����, ����任��Ľ�
%  s1 = [1 2 3 4 5]
% ���ѡȡһ�β��뵽��һ��λ�ã���[2 3]���뵽4������[1 4 2 3 5]
numLimit = size(s1,2);
randP = randperm(numLimit,2);% ���ѡ������
p1 = min(randP);
p2 = max(randP);
if p1==1 && p2==numLimit % ��ֹȫѡ��
    p1=round(numLimit/2);
end
sChoose = s1(p1:p2);
sLeft = [s1(1:p1-1),s1(p2+1:numLimit)];
insertP = randperm(numLimit-(p2-p1+1),1);% ȥ��ѡ����һ�Σ�������λ��
s2 = [sLeft(1:insertP),sChoose,sLeft(insertP+1:numLimit-(p2-p1+1))];
end
%% ������� IM
function s2 = mutateIM(s1)
% ����һ����, ����任��Ľ�
%  s1 = [1 2 3 4 5]
% ���ѡȡһ�����뵽��һ��λ�ã���2���뵽4������[1 3 4 2 5]
numLimit = size(s1,2);
p1 = randperm(numLimit,1);% ���ѡ
sLeft = [s1(1:p1-1),s1(p1+1:numLimit)];
p2 = randperm(numLimit-1,1);% ʣ�µ�������ѡһ��λ��
s2 = [sLeft(1:p2),s1(p1),sLeft(p2+1:numLimit-1)];
end
%% �򵥵�λ���� SIM
function s2 = mutateSIM(s1)
% ����һ����, ����任��Ľ�
%  s1 = [1 2 3 4 5]
% ���ѡȡһ�εĵ���
numLimit = size(s1,2);
r = randperm(numLimit,2);% ���ѡ
p1 = min(r);
p2 = max(r);
indexBack = p1:p2;
indexBack = fliplr(indexBack);
s2 = [s1(1:p1-1),s1(indexBack),s1(p2+1:numLimit)];
end
%% ��λ���� IVM
function s2 = mutateIVM(s1)
% ����һ����, ����任��Ľ�
%  s1 = [1 2 3 4 5]
% ���ѡȡһ�εĵ���
numLimit = size(s1,2);
randP = randperm(numLimit,2);% ���ѡ������
p1 = min(randP);
p2 = max(randP);
if p1==1 && p2==numLimit % ��ֹȫѡ��
    p1=round(numLimit/2);
end
sChoose = s1(p1:p2);
sLeft = [s1(1:p1-1),s1(p2+1:numLimit)];
insertP = randperm(numLimit-(p2-p1+1),1);% ȥ��ѡ����һ�Σ�������λ��
s2 = [sLeft(1:insertP),fliplr(sChoose),sLeft(insertP+1:numLimit-(p2-p1+1))];
end
%% �������
function s2 = mutateSM(s1)
% ����һ����, ����任��Ľ�
%  s1 = [1 2 3 4 5]
% ���ѡȡһ�Σ�ѡ�е�һ�Σ���һ�������Ӵ�����
numLimit = size(s1,2);
randP = randperm(numLimit,2);% ���ѡ������
p1 = min(randP);
p2 = max(randP);
s2=[s1(1:p1-1),s1(p1+1:p2),s1(p1),s1(p2+1:numLimit)];
end
%% �ڽӱ���
function s2 = mutateLM(s1)
% ѡһ�����������Ԫ�ؽ���
numLimit = size(s1,2);
p1 = randperm(numLimit,1);% ���ѡ1����
p2 = p1+1;
if p2 >numLimit
    p2 = p2-1;
end
tmp = s1(p1);
s1(p1) = s1(p2);
s1(p2) = tmp;
s2 = s1;
end