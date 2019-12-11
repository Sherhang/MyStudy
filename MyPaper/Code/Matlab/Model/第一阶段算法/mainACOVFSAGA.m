
% ACOVFSAGA �� GA IGA SAGA �Ƚϣ� GA ѡ��PMX_EM 
% ����һ��
Repetition= 2; % �㷨�ظ�����
popsize=20;steps=200;Pcross=0.4;Pmutate=0.4; 
Top = 50; Dop = 0.95;

fB = zeros(Repet,steps+1);
fM = zeros(Repet,steps+1);
XC = zeros(Repet,steps,5);
XM = zeros(Repet,steps,7);
t = zeros(Repet,1);
for i=1:Repet
    [plan, fB(i,:),fM(i,:),XC(i,:,:),XM(i,:,:), t(i)] = ACOVFSAGA(obj,2*popsize,steps,Pcross,Pmutate,Top,Dop);
end
planACO = plan;
fBestSaveACO = mean(fB);
fMeanSaveACO = mean(fM);
XcrossSave = mean(XC,1);
XmutateSave= mean(XM,1);
timeACO = mean(t);


% GA_PMX-EM
fB = zeros(Repet,steps+1);
fM = zeros(Repet,steps+1);
t =  zeros(Repet,1); 
for i =1:Repet
    [planGA_PMX_EM, fB(i,:),fM(i,:), t(i)] = GA1(obj,popsize,steps,Pcross,Pmutate, "PMX", "SIM");
end
fBestSaveGA_PMX_SIM = mean(fB);
fMeanSaveGA_PMX_SIM = mean(fM);
timeGA_PMX_EM = mean(t);
% SAGA_OX2-EM
fB = zeros(Repetition,steps+1);
fM = zeros(Repetition,steps+1);
t =  zeros(Repetition,1);
for i =1:Repetition
    [planGA_OX2_EM, fB(i,:),fM(i,:), t(i)] = SAGA(obj,popsize,steps,Pcross,Pmutate, "OX2", "DM",Top,Dop);
end
fBestSaveSAGA_OX2_DM = mean(fB);
fMeanSaveSAGA_OX2_DM = mean(fM);
timeSAGA_OX2_EM = mean(t);

% % ACOVFSAGA
% [plan, fBestSaveACO,fMeanSaveACO,XcrossSave,XmutateSave, timeACO] = ACOVFSAGA(obj,40,steps,Pcross,Pmutate,Top,Dop);
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSaveACO);hold on;
plot(fBestSaveGA_PMX_SIM);hold on;
plot(fBestSaveSAGA_OX2_DM);hold on;
plot(fMeanSaveACO);hold on;
plot(fMeanSaveGA_PMX_SIM);hold on;
plot(fMeanSaveSAGA_OX2_DM);hold on;
legend("ACOVFSAGA���Ÿ���","GA\_PMX\_SIM���Ÿ���","SAGA\_OX2\_EM���Ÿ���"...
    ,"ACOVFSAGA��Ⱥ��ֵ","GA\_PMX\_SIM��Ⱥ��ֵ","SAGA\_OX2\_EM��Ⱥ��ֵ");
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
axis([0 280 0.47 0.55]);
print(figure1,'-dpng','-r300','./png/ACO.png')   % ���浽����Ŀ¼��

figure2=figure('color',[1 1 1]);
for i=1:5
    plot(XcrossSave(:,:,i));hold on;
end
legend('PMX','OX1','OX2','CX','PBX');
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
% axis([0 250 0.19 0.21]);
print(figure2,'-dpng','-r300','./png/ACOXCross.png')   % ���浽����Ŀ¼��

figure3=figure('color',[1 1 1]);
for i=1:7
    plot(XmutateSave(:,:,i));hold on;
end
legend("EM","DM","IM","SIM","IVM","SM","LM");
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.45]);%�ԣ�0.2��0.2��Ϊԭ�㣬��0.5����0.45
% axis([0 250 0.12 0.16]);
print(figure3,'-dpng','-r300','./png/ACOXMutate.png')   % ���浽����Ŀ¼��