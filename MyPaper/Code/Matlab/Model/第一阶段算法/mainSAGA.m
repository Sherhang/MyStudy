% �����㷨�ıȽϽű�
% �ڴ�֮����������ģ��һ��ʱ�䣬Ȼ����ͣ
% ����
Top = 100; Dop = 0.95;
%% SAGA�㷨����
% �����㷨�ıȽϽű�
% �ڴ�֮����������ģ��һ��ʱ�䣬Ȼ����ͣ�����߼���objģ��
% ����
Repetition = 20; % ÿ���㷨���ظ�����
%% GA1�㷨����
popsize=20;steps=200;Pcross=0.4;Pmutate=0.4;
%----------�ȽϽ�������------------
% PMX-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1); 
for i =1:Repetition
    [planGA_PMX_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM",Top,Dop);
end
fBestSave_PMX_EM = mean(fB);
fMeanSave_PMX_EM = mean(fM);
time_PMX_EM = mean(t);
% OX1-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_OX1_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "OX1", "EM",Top,Dop);
end
fBestSave_OX1_EM = mean(fB);
fMeanSave_OX1_EM = mean(fM);
time_OX1_EM = mean(t);
% OX2-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_OX2_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "OX2", "EM",Top,Dop);
end
fBestSave_OX2_EM = mean(fB);
fMeanSave_OX2_EM = mean(fM);
time_OX2_EM = mean(t);
% CX-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_OX2_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "CX", "EM",Top,Dop);
end
fBestSave_CX_EM = mean(fB);
fMeanSave_CX_EM = mean(fM);
time_CX_EM = mean(t);
% PBX-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PBX_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PBX", "EM",Top,Dop);
end
fBestSave_PBX_EM = mean(fB);
fMeanSave_PBX_EM = mean(fM);
time_PBX_EM = mean(t);
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSave_PMX_EM);hold on;
plot(fBestSave_OX1_EM);hold on;
plot(fBestSave_OX2_EM);hold on;
plot(fBestSave_CX_EM);hold on;
plot(fBestSave_PBX_EM);hold on;

plot(fMeanSave_PMX_EM);hold on;
plot(fMeanSave_OX1_EM);hold on;
plot(fMeanSave_OX2_EM);hold on;
plot(fMeanSave_CX_EM);hold on;
plot(fMeanSave_PBX_EM);hold on;
legend('PMX\_EM���Ÿ���','OX1\_EM���Ÿ���','OX2\_EM���Ÿ���','CX\_EM���Ÿ���','PBX\_EM���Ÿ���',...
'PMX\_EM��Ⱥ��ֵ','OX1\_EM��Ⱥ��ֵ','OX2\_EM��Ⱥ��ֵ','CX\_EM��Ⱥ��ֵ','PBX\_EM��Ⱥ��ֵ');
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
axis([0 260 0.47 0.55]);
print(figure1,'-dpng','-r300','./png/SAGACross.png')   % ���浽����Ŀ¼��


%-----------�Ƚϱ�������---------
% PMX-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM",Top,Dop);
end
fBestSave_PMX_EM = mean(fB);
fMeanSave_PMX_EM = mean(fM);
time_PMX_EM = mean(t);
% PMX_DM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_DM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "DM",Top,Dop);
end
fBestSave_PMX_DM = mean(fB);
fMeanSave_PMX_DM = mean(fM);
time_PMX_DM = mean(t);
% PMX_IM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_IM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "IM",Top,Dop);
end
fBestSave_PMX_IM = mean(fB);
fMeanSave_PMX_IM = mean(fM);
time_PMX_IM = mean(t);
% PMX_SIM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_SIM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "SIM",Top,Dop);
end
fBestSave_PMX_SIM = mean(fB);
fMeanSave_PMX_SIM = mean(fM);
time_PMX_SIM = mean(t);
% PMX_IVM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_IVM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "IVM",Top,Dop);
end
fBestSave_PMX_IVM = mean(fB);
fMeanSave_PMX_IVM = mean(fM);
time_PMX_IVM = mean(t);
% PMX_SM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_SM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "SM",Top,Dop);
end
fBestSave_PMX_SM = mean(fB);
fMeanSave_PMX_SM = mean(fM);
time_PMX_SM = mean(t);
% PMX_LM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_PMX_LM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "PMX", "LM",Top,Dop);
end
fBestSave_PMX_LM = mean(fB);
fMeanSave_PMX_LM = mean(fM);
time_PMX_LM = mean(t);
%------------plot------------
figure2 = figure('color',[1 1 1]);
plot(fBestSave_PMX_EM);hold on;
plot(fBestSave_PMX_DM);hold on;
plot(fBestSave_PMX_IM);hold on;
plot(fBestSave_PMX_SIM);hold on;
plot(fBestSave_PMX_IVM);hold on;
plot(fBestSave_PMX_SM);hold on;
plot(fBestSave_PMX_LM);hold on;

plot(fMeanSave_PMX_EM);hold on;
plot(fMeanSave_PMX_DM);hold on;
plot(fMeanSave_PMX_IM);hold on;
plot(fMeanSave_PMX_SIM);hold on;
plot(fMeanSave_PMX_IVM);hold on;
plot(fMeanSave_PMX_SM);hold on;
plot(fMeanSave_PMX_LM);hold on;

legend('PMX\_EM���Ÿ���','PMX\_DM���Ÿ���','PMX\_IM���Ÿ���','PMX\_SIM���Ÿ���'...
   ,'PMX\_IVM���Ÿ���' ,'PMX\_SM���Ÿ���', 'PMX\_LM���Ÿ���'...
   ,'PMX\_EM��Ⱥ��ֵ','PMX\_DM��Ⱥ��ֵ','PMX\_IM��Ⱥ��ֵ','PMX\_SIM��Ⱥ��ֵ'...
    ,'PMX\_IVM��Ⱥ��ֵ','PMX\_SM��Ⱥ��ֵ','PMX\_LM��Ⱥ��ֵ');
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
axis([0 260 0.47 0.55]);
print(figure2,'-dpng','-r300','./png/SAGAMutate.png')   % ���浽����Ŀ¼��

% ��35���㷨����
algoCross=["PMX","OX1","OX2","CX","PBX"];
algoMutate=["EM","DM","IM","SIM","IVM","SM","LM"];
numCross = length(algoCross);
numMutate = length(algoMutate);

for p=1:numCross
    for q=1:numMutate
        fB = zeros(Repetition,steps+1);
        fM = zeros(Repetition,steps+1);
        t =  zeros(Repetition,1);
        for i =1:Repetition
            [planGA_PMX_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate,algoCross(p), algoMutate(q),Top,Dop);
        end
        fB =  mean(fB);
        AlgBestSave(p,q)= max(fB); % ƽ������ֵ
        AlgMinSteps(p,q) = 0; % ����õ��������Ž��ʱ��
        for j=1:length(fB)
            if abs(fB(j)- AlgBestSave(p,q))<0.000001
                AlgMinSteps(p,q) = j;
                break;
            end
        end
        %         fMeanSave_PMX_EM = mean(fM);
        AlgTime(p,q) = mean(t); % ƽ��ʱ��
    end
end
