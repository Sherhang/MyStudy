% 各种算法的比较脚本
% 在此之间请先运行模型一段时间，然后暂停
%% GA1算法部分
popsize=10;steps=200;Pcross=0.4;Pmutate=0.4;
%----------比较交叉算子------------
[planGA_PMX_EM, fBestSave_PMX_EM,fMeanSave_PMX_EM, time_PMX_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM");
[planGA_OX1_EM, fBestSave_OX1_EM,fMeanSave_OX1_EM, time_OX1_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "OX1", "EM");
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSave_PMX_EM);hold on;
plot(fMeanSave_PMX_EM);hold on;
plot(fBestSave_OX1_EM);hold on;
plot(fMeanSave_OX1_EM);hold on;
legend('PMX\_EM最优个体','PMX\_EM种群均值','OX1\_EM最优个体','OX1\_EM种群均值');
%-----------比较变异算子---------
[planGA_PMX_EM, fBestSave_PMX_EM,fMeanSave_PMX_EM, time_PMX_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM");
[planGA_PMX_DM, fBestSave_PMX_DM,fMeanSave_PMX_DM, time_PMX_DM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "DM");
[planGA_PMX_IM, fBestSave_PMX_IM,fMeanSave_PMX_IM, time_PMX_IM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "IM");
[planGA_PMX_SIM, fBestSave_PMX_SIM,fMeanSave_PMX_SIM, time_PMX_SIM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "SIM");
[planGA_PMX_IVM, fBestSave_PMX_IVM,fMeanSave_PMX_IVM, time_PMX_IVM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "IVM");
[planGA_PMX_SM, fBestSave_PMX_SM,fMeanSave_PMX_SM, time_PMX_SM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "SM");
[planGA_PMX_LM, fBestSave_PMX_LM,fMeanSave_PMX_LM, time_PMX_LM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "LM");
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


