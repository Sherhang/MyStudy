% �Ŵ��㷨����һ�׶�ģ�ͣ�������ʽ����Ҫ��ע�ĵ�������㷨������ʱ�䣬�㷨�ĵ���
% �ο�MATLAB�����Ż��㷨
% ����obj��ģ��
%         �Ŵ��㷨�Ĳ�������Ⱥ����popsize����������steps���������Pcross���������Pmutate���������ѡ�񣬱������ѡ��
% ���: ʮ���Ʊ���Ľ�planGA����[2 3 1 4]
%       fBestSave ��ÿһ����õĽ��¼
%       fMeanSave , ÿһ��ƽ�����¼
% test: [planGA, fBestSave,fMeanSave, time] = GA1(obj,100,100,1,0.5)
function [planGA, fBestSave,fMeanSave, time] = GA1(obj,popsize,steps,Pcross,Pmutate)
%  popsize = 10;steps=100;Pcross=0.5;Pmutate = 0.5;
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
    sCross = cross(sSelect, s, Pcross); % ����
    s = mutate(sCross, Pmutate); % ����
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
% ���룺��Ⱥs(popsize,numLimit),��Ⱥ�������ӦֵfitPop(popsize,1);
% �����ѡ�����ȺsSelect(popsize,n)
% test: s=[1 2 3;2 3 1;3 1 2;4 1 3];fitPop = [1 1 4 2];
function sSelect =  selectByGamble(s, fitPop)
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
% 
%% �������Ӳ���ѡ��������Ⱥ������Ⱥ���档���������������彻�棬����ú������������彻��
% ���룺s(popsize,numLimit)����Ⱥ��sSelect(popsize,numLimit)ѡ��֮�����Ⱥ��Pcross
% �������������0.4-0.99֮��
% �����sCross ��������֮�����Ⱥ
function sCross = cross(s1, s2, Pcross) % s1��ѡ��֮�����Ⱥ
[popsize, numLimit] = size(s1);
sCross = zeros(popsize, numLimit);
s2 = s1(randperm(popsize),:); % ��һ���ǲ��������棬����˳��������ú�����Ⱥ���棬ע�͵�����
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pcross  % ����
      [sCross(i,:), ~] = crossPMX(s1(i,:),s2(i,:));
    else
       sCross(i,:) = s1(i,:);
    end
end
end
%% crossPMX ����ƥ�䷨,ԭ�㷨��ȱ�ݣ�Ŀǰ�Ѿ�ȥ���˿���������Ľ�
function [child1,child2] = crossPMX(P1, P2)

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
%% ѭ�����淨
function [child1, child2] = crossCX()
end
% ��������
%% Ⱥ�����
function sMutate = mutate(s, Pmutate)
[popsize, ~] = size(s);
sMutate = s;
pRand = rand(popsize,1);
for i=1:popsize
    if pRand(i) < Pmutate
        sMutate(i,:) = mutateEM(s(i,:)); % 2-��������
    end
end
end
%% 2-�������� EM, 
function s2 = mutateEM(s1)
numLimit = size(s1,2);
p= randperm(numLimit,2);
s2 = s1;
s2(p(1)) = s1(p(2));
s2(p(2)) = s1(p(1));
end 