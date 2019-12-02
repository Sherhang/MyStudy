% 各种算法的比较脚本
% 在此之间请先运行模型一段时间，然后暂停
% 常量
Repetition = 10; % 每个算法的重复次数
Top = 100; Dop = 0.95;
%% SAGA算法部分
popsize=20;steps=200;Pcross=0.4;Pmutate=0.4;
%----------比较交叉算子------------
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
legend('PMX\_EM最优个体','PMX\_EM种群均值','OX1\_EM最优个体','OX1\_EM种群均值');
%-----------比较变异算子---------
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
legend('PMX\_EM最优个体','PMX\_EM种群均值','PMX\_DM最优个体','PMX\_DM种群均值',...
    'PMX\_IM最优个体','PMX\_IM种群均值','PMX\_SIM最优个体','PMX\_SIM种群均值',...
    'PMX\_IVM最优个体','PMX\_IVM种群均值','PMX\_SM最优个体','PMX\_SM种群均值',...
    'PMX\_LM最优个体','PMX\_LM种群均值');


