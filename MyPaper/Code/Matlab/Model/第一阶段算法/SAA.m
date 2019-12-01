% Simulated annealing algorithm SAA�㷨 ģ���˻��㷨
%% ������ʽ��
function  [sBest, fBestSave, fCurrent, time]  = SAA(obj,t,d,steps,Markov_length, Pmutate,mutateAlg)
% obj ģ�� t��ʼ�¶ȣ�d�¶�˥�����ӣ�steps��������, Markov_length�ڲ�ѭ�������� Pmutate������ʣ�mutateALG�㷨ѡ��
% [sBest, fBestSave, fCurrent, time] = SAA(obj,100,0.95,200,100,0.4,"mutateDM");plot(fCurrent);hold on;plot(fBestSave);

tic;
if nargin<6
    mutateAlg="DM";
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
        mutateHandle = @mutateSM;
end
numLimit = max(obj.numOfMissiles, sum(obj.targetList)); % ����ά��
s = randperm(numLimit); % ��ʼ��
plan = decodeFromHA(obj,s);
f = ModelFighters(obj, plan); % ��ǰ����ֵ
sBest = s; %��¼���Ž�
fCurrent = zeros(steps,1); % ��ǰ��Ӧ�ĺ���ֵ
fBestSave = zeros(steps,1); % ���Ž��Ӧ�ĺ���ֵ
fBest = f; % ȫ�����Ž�
fCurrent(1) = f;fBestSave(1)=f;
% ��ѭ��
for step=2:steps
    fCurrent(step) = f;
    for k=1:Markov_length
        if rand() < Pmutate
            sNew = mutateHandle(s); % �����µĽ�  
            planNew = decodeFromHA(obj,sNew);
            fNew = ModelFighters(obj, planNew); % ����ֵ
            if fNew > f
                fCurrent(step) = fNew;
                sBest = sNew;
                s = sNew;f=fNew;
                if fNew > fBest
                    fBest = fNew;
                end
            else
                if rand() <exp(-(f-fNew)/t) % ��һ�����ʽ��ܲ�Ľ�
                    fCurrent(step) = fNew;
                    s = sNew;f=fNew;
                    if fNew > fBest
                        fBest = fNew;
                    end
                end
            end
        end
    end

    fBestSave(step) = fBest;
    t = t*d;
end

toc
time = toc;
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