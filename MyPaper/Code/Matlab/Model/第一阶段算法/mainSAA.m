

T = 100;d =0.95; steps = 200;
Markov_length=20;Pmutate=0.4;
algs = ["EM","DM","IM","SIM","IVM","SM","LM"];
Repetition = 20; % ÿ���㷨���ظ�����

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planEM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"EM");
end
fBestSaveEM = mean(fB);
fCurrentSaveEM = mean(fC);
timeEM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planDM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"DM");
end
fBestSaveDM = mean(fB);
fCurrentSaveDM = mean(fC);
timeDM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planIM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"IM");
end
fBestSaveIM = mean(fB);
fCurrentSaveIM = mean(fC);
timeIM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planSIM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"SIM");
end
fBestSaveSIM = mean(fB);
fCurrentSaveSIM = mean(fC);
timeSIM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planIVM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"IVM");
end
fBestSaveIVM = mean(fB);
fCurrentSaveIVM = mean(fC);
timeIVM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planSM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"SM");
end
fBestSaveSM = mean(fB);
fCurrentSaveSM = mean(fC);
timeSM = mean(t);

fB = zeros(Repetition,steps);
fC = zeros(Repetition,steps);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planLM, fB(i,:),fC(i,:), t(i)] = SAA(obj,T,d,steps,Markov_length, Pmutate,"LM");
end
fBestSaveLM = mean(fB);
fCurrentSaveLM = mean(fC);
timeLM = mean(t);

minStepsSAA=zeros(7,1);
fBestSAA=zeros(7,1);
%-------��������---
for i=1:steps
    if abs(fBestSaveEM(i)-fBestSaveEM(steps)) < 0.00001
        minStepSAAEM = i
        minStepsSAA(1) = i;
        fBestSAA(1) = fBestSaveEM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveDM(i)-fBestSaveDM(steps)) < 0.00001
        minStepSAADM = i
        minStepsSAA(2) = i;
        fBestSAA(2) = fBestSaveDM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveIM(i)-fBestSaveIM(steps)) < 0.00001
        minStepSAAIM = i
        minStepsSAA(3) = i;
        fBestSAA(3) = fBestSaveIM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveSIM(i)-fBestSaveSIM(steps)) < 0.00001
        minStepSAASIM = i
        minStepsSAA(4) = i;
        fBestSAA(4) = fBestSaveSIM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveIVM(i)-fBestSaveIVM(steps)) < 0.00001
        minStepSAAIVM = i
        minStepsSAA(5) = i;
        fBestSAA(5) = fBestSaveIVM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveSM(i)-fBestSaveSM(steps)) < 0.00001
        minStepSAASM = i
        minStepsSAA(6) = i;
        fBestSAA(6) = fBestSaveSM(steps);
        break;
    end
end
for i=1:steps
    if abs(fBestSaveLM(i)-fBestSaveLM(steps)) < 0.00001
        minStepSAALM = i
        minStepsSAA(7) = i;
        fBestSAA(7) = fBestSaveLM(steps);
        break;
    end
end
timeSAA = [timeEM;timeDM;timeIM;timeSIM;timeIVM;timeSM;timeLM]




%----------plot-------
figure1 = figure('color',[1 1 1]);
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
% set (gca,'position',[0.1,0.1,0.9,0.8] );
plot(fBestSaveEM );hold on;
plot(fBestSaveDM );hold on;
plot(fBestSaveIM );hold on;
plot(fBestSaveSIM );hold on;
plot(fBestSaveIVM );hold on;
plot(fBestSaveSM );hold on;
plot(fBestSaveLM );hold on;

plot(fCurrentSaveEM);hold on;
plot(fCurrentSaveDM);hold on;
plot(fCurrentSaveIM);hold on;
plot(fCurrentSaveSIM);hold on;
plot(fCurrentSaveIVM);hold on;
plot(fCurrentSaveSM);hold on;
plot(fCurrentSaveLM);hold on;

legend("EM����ֵ","DM����ֵ","IM����ֵ","SIM����ֵ","IVM����ֵ","SM����ֵ","LM����ֵ",...
    "EM��ǰֵ","DM��ǰֵ","IM��ǰֵ","SIM��ǰֵ","IVM��ǰֵ","SM��ǰֵ","LM��ǰֵ");
axis([0 240 0.47 0.54]);xlabel("step");ylabel("��Ӧ��");
print(figure1,'-dpng','-r300','./png/SAA.png')   % ���浽����Ŀ¼��





%% ������ʽ��Simulated annealing algorithm SAA�㷨 ģ���˻��㷨
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
fCurrent = zeros(1,steps); % ��ǰ��Ӧ�ĺ���ֵ
fBestSave = zeros(1,steps); % ���Ž��Ӧ�ĺ���ֵ
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