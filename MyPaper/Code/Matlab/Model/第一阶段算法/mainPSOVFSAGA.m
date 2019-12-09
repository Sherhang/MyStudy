
popsize=100;steps=200;Pcross=0.4;Pmutate=0.4; 
Top = 100; Dop = 0.95;
[plan, fBestSave,fMeanSave,XcrossSave,XmutateSave, time] = PSOVFSAGA(obj,popsize,steps,Pcross,Pmutate,Top,Dop);
%------------plot------------
figure1 = figure('color',[1 1 1]);
plot(fBestSave);hold on;
plot(fMeanSave);hold on;

figure2=figure('color',[1 1 1]);
for i=1:5
    plot(XcrossSave(:,i));hold on;
end
legend('PMX','OX1','OX2','CX','PBX');