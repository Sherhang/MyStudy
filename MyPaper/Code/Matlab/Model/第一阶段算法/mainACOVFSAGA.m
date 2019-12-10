
% ACOVFSAGA �� GA IGA SAGA �Ƚϣ� GA ѡ��PMX_EM 
% ����һ��
popsize=20;steps=200;Pcross=0.4;Pmutate=0.4; 
Top = 50; Dop = 0.95;



% PMX-EM
[planGA_PMX_EM, fBestSaveGA_PMX_EM,fMeanSaveGA_PMX_EM, timeGA_PMX_EM] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "EM");
% ACOVFSAGA
[plan, fBestSaveACO,fMeanSaveACO,XcrossSave,XmutateSave, timeACO] = ACOVFSAGA(obj,popsize,steps,Pcross,Pmutate,Top,Dop);
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSaveACO);hold on;
plot(fBestSaveGA_PMX_EM);hold on;
plot(fMeanSaveACO);hold on;
plot(fMeanSaveGA_PMX_EM);hold on;
legend("ACOVFSAGA���Ÿ���","GA\_PMX\_EM���Ÿ���","ACOVFSAGA��Ⱥ��ֵ","GA\_PMX\_EM��Ⱥ��ֵ");


figure2=figure('color',[1 1 1]);
for i=1:5
    plot(XcrossSave(:,i));hold on;
end
legend('PMX','OX1','OX2','CX','PBX');
figure3=figure('color',[1 1 1]);
for i=1:7
    plot(XmutateSave(:,i));hold on;
end
legend("EM","DM","IM","SIM","IVM","SM","LM");