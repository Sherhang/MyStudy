% �����㷨�ıȽϽű�
% �ڴ�֮����������ģ��һ��ʱ�䣬Ȼ����ͣ
%% GA1�㷨����
popsize=10;steps=200;Pcross=0.4;Pmutate=0.4;
%----------�ȽϽ�������------------
[planGA_PMX_EM, fBestSave_PMX_EM,fMeanSave_PMX_EM, time_PMX_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM");
[planGA_OX1_EM, fBestSave_OX1_EM,fMeanSave_OX1_EM, time_OX1_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "OX1", "EM");
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSave_PMX_EM);hold on;
plot(fMeanSave_PMX_EM);hold on;
plot(fBestSave_OX1_EM);hold on;
plot(fMeanSave_OX1_EM);hold on;
legend('PMX\_EM���Ÿ���','PMX\_EM��Ⱥ��ֵ','OX1\_EM���Ÿ���','OX1\_EM��Ⱥ��ֵ');
%-----------�Ƚϱ�������---------
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
legend('PMX\_EM���Ÿ���','PMX\_EM��Ⱥ��ֵ','PMX\_DM���Ÿ���','PMX\_DM��Ⱥ��ֵ',...
    'PMX\_IM���Ÿ���','PMX\_IM��Ⱥ��ֵ','PMX\_SIM���Ÿ���','PMX\_SIM��Ⱥ��ֵ',...
    'PMX\_IVM���Ÿ���','PMX\_IVM��Ⱥ��ֵ','PMX\_SM���Ÿ���','PMX\_SM��Ⱥ��ֵ',...
    'PMX\_LM���Ÿ���','PMX\_LM��Ⱥ��ֵ');


