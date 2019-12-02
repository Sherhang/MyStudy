% �����㷨�ıȽϽű�
% �ڴ�֮����������ģ��һ��ʱ�䣬Ȼ����ͣ
% ����
Repetition = 10; % ÿ���㷨���ظ�����
Top = 100; Dop = 0.95;
%% SAGA�㷨����
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
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSave_PMX_EM);hold on;
plot(fMeanSave_PMX_EM);hold on;
plot(fBestSave_OX1_EM);hold on;
plot(fMeanSave_OX1_EM);hold on;
legend('PMX\_EM���Ÿ���','PMX\_EM��Ⱥ��ֵ','OX1\_EM���Ÿ���','OX1\_EM��Ⱥ��ֵ');
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
plot(fMeanSave_PMX_EM);hold on;
plot(fBestSave_PMX_DM);hold on;
plot(fMeanSave_PMX_DM);hold on;
plot(fBestSave_PMX_IM);hold on;
plot(fMeanSave_PMX_IM);hold on;
plot(fBestSave_PMX_SIM);hold on;
plot(fMeanSave_PMX_SIM);hold on;
plot(fBestSave_PMX_IVM);hold on;
plot(fMeanSave_PMX_IVM);hold on;
plot(fBestSave_PMX_SM);hold on;
plot(fMeanSave_PMX_SM);hold on;
plot(fBestSave_PMX_LM);hold on;
plot(fMeanSave_PMX_LM);hold on;
legend('PMX\_EM���Ÿ���','PMX\_EM��Ⱥ��ֵ','PMX\_DM���Ÿ���','PMX\_DM��Ⱥ��ֵ',...
    'PMX\_IM���Ÿ���','PMX\_IM��Ⱥ��ֵ','PMX\_SIM���Ÿ���','PMX\_SIM��Ⱥ��ֵ',...
    'PMX\_IVM���Ÿ���','PMX\_IVM��Ⱥ��ֵ','PMX\_SM���Ÿ���','PMX\_SM��Ⱥ��ֵ',...
    'PMX\_LM���Ÿ���','PMX\_LM��Ⱥ��ֵ');


