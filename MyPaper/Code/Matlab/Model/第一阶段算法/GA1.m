% �Ŵ��㷨����һ�׶�ģ�ͣ���Ҫ��ע�ĵ�������㷨������ʱ�䣬�㷨�ĵ���
% �ο�MATLAB�����Ż��㷨
function [planGA, fBestSave,fMeanSave, time] = GA1(obj,popsize,steps,Pcross,Pmutate, crossAlg, mutateAlg)
% ����obj��ģ��
%         �Ŵ��㷨�Ĳ�������Ⱥ����popsize����������steps���������Pcross���������Pmutate���������ѡ��crossAlg���������ѡ��mutateAlg
%                                                          ͨ��ȡ������ʣ�0.4-0.99��������ʣ�0.001-0.2��
%                                                             
% ���: ʮ���Ʊ���Ľ�planGA����[2 3 1 4]
%       fBestSave ��ÿһ����õĽ��¼
%       fMeanSave , ÿһ��ƽ�����¼
% test: [planGA, fBestSave,fMeanSave, time] = GA1(obj,100,100,1,0.5,"PMX","EM")
if nargin < 7
     mutateAlg="EM"; % ""��ʾ�ַ���������һ������
end
if nargin<6
    crossAlg = "PMX";
    mutateAlg="EM";
end
tic; % ��¼����ʼʱ��
%-----��Ⱥ��ʾ��ʽ--------
% s(popsize,numLimit),numLimit��ʾ��ķ�Χ����10*8�ľ����Ӧ1-10��һ������
% ������ʼ��Ⱥ
numLimit = max(obj.numOfMissiles, sum(obj.targetList));
s = zeros(popsize,numLimit); % Ԥ�����ڴ�
for i=1:popsize
    s(i,:) = randperm(numLimit);
end
% һЩ��ʼ����
fBestSave = zeros(1,steps); % ÿһ����õĽ��¼
fMeanSave = zeros(1,steps); % ÿһ��ƽ�����¼
fitPop = rand(popsize,1);    % ÿ������ĺ���ֵ������Ӧ�ȣ�Խ��Խ��
% ������Ӧ�Ⱥ���
for i=1:popsize
    plan = decodeFromHA(obj,s(i,:));
    fitPop(i) = ModelFighters(obj, plan);
end
%% ��ѭ����ʼ
for step=1:steps
    % �ȱ���һЩ��Ҫ�ı���
    [fBestSave(step), maxIndex] =  max(fitPop);
    bestPlan = s(maxIndex,:); % ���ŽⱣ��
    fMeanSave(step) = mean(fitPop);
    sSelect =  selectByGamble(s, fitPop); % ѡ��
    sCross = cross(sSelect, s, Pcross,crossAlg); % ����
    s = mutate(sCross, Pmutate, mutateAlg); % ����
    s(randperm(popsize,1),:) = bestPlan; % ���Ž�ȡ����
    % ������Ӧ�Ⱥ�����
    for i=1:popsize
        plan = decodeFromHA(obj,s(i,:));
        fitPop(i) = ModelFighters(obj, plan);
    end
end
%%
toc;  % ��ʱ����
time = toc; % �㹻��ȷ
[fBestSave(step+1), maxIndex] =  max(fitPop);
fMeanSave(step+1) = mean(fitPop);
planGA = s(maxIndex,:); % ���ŽⱣ��
end
% �������Ӳ���
%% ���̶�ѡ������,��ӦֵԽ��Խ���ױ�ѡ���������Ӧֵ��ĸ�����
function sSelect =  selectByGamble(s, fitPop)
% ���룺��Ⱥs(popsize,numLimit),��Ⱥ�������ӦֵfitPop(popsize,1);
% �����ѡ�����ȺsSelect(popsize,n)
% test: s=[1 2 3;2 3 1;3 1 2;4 1 3];fitPop = [1 1 4 2];
[popsize, numLimit] = size(s);
sSelect = zeros(popsize, numLimit);
chooseP = fitPop/sum(fitPop); % ���Ա�ѡ���ĸ���
chooseP = cumsum(chooseP);  % ÿһ��Ϊ֮ǰ������֮�ͣ���[1 2 3]--> [1 1+2 1+2+3]
randP = rand(5*popsize,1); % �����㹻����������
k=1;t=1;% k����ѡ��popsize������
while k<=popsize
    for i=1:popsize
        if (randP(t) < chooseP(i))  % ѡ�е�i��
            sSelect(k,:) = s(i,:);
            k = k+1;
            break;
        end
    end
    t = t+1;
    if t>5*popsize
        t = t-5*popsize;
    end
end
end
%% Ⱥ�彻�档�������Ӳ���ѡ��������Ⱥ������Ⱥ���档���������������彻�棬����ú������������彻��
function sCross = cross(s1, s2, Pcross,crossAlg) % s1��ѡ��֮�����Ⱥ
% ���룺s(popsize,numLimit)����Ⱥ��sSelect(popsize,numLimit)ѡ��֮�����Ⱥ��Pcross������ʣ�crossAlg��������ѡ��
% �������������0.4-0.99֮��
% �����sCross ��������֮�����Ⱥ
if nargin<4
    crossAlg="PMX";
end
switch crossAlg
    case "PMX"
        crossHandle = @crossPMX;% �������
    case "OX1"
        crossHandle = @crossOX1;
    otherwise
        crossHandle = @crossPMX;
end
    
[popsize, numLimit] = size(s1);
sCross = zeros(popsize, numLimit);
s2 = s1(randperm(popsize),:); % ��һ���ǲ��������棬����˳��������ú�����Ⱥ���棬ע�͵�����
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pcross  % ����
      [sCross(i,:), ~] = crossHandle(s1(i,:),s2(i,:));  % ����ѡ�񽻲�����
    else
       sCross(i,:) = s1(i,:);
    end
end
end
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
chb1=min(r)-1; % ����-1��Ϊ�˺Ͷ���һ�����������Ҳת��
chb2=max(r);
chb1=4-1;chb2=6;
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
% ���룬�����⣬��s1=[1 2 3 4], s2=[2 4 3 1],�����������λ����2 4
% ����������µĽ⣬child1=[ 4 2 3 1],child2 =  [2 1 3 4]
numLimit=size(s1,2);
scro = [s1;s2];
r = randperm(numLimit,2); %��[1,numLimit]��Χ���������2������λ
chb1=min(r);
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
%% ѭ�����淨
function [child1, child2] = crossCX()
end
% ��������
%% Ⱥ�����
function sMutate = mutate(s, Pmutate,mutateAlg)
if nargin<3
    mutateAlg="EM";
end
switch mutateAlg
    case "EM"
        mutateHandle = @mutateEM;% �������
    case "DM"
        mutateHandle = @mutateDM;% �������
    case "IM"
        mutateHandle = @mutateIM;% �������
    case "SIM"
        mutateHandle = @mutateSIM;% �������
    case "IVM"
        mutateHandle = @mutateIVM;% �������
    case "SM"
        mutateHandle = @mutateSM;% �������
    case "LM"
        mutateHandle = @mutateLM;% �������
    otherwise
        mutateHandle = @mutateEM;
end
[popsize, ~] = size(s);
sMutate = s;
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pmutate
        sMutate(i,:) = mutateHandle(s(i,:)); % ����ѡ��
    end
end
end
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