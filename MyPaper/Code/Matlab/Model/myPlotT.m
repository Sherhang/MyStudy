% ģ���˻���¶ȱ仯
clear;clc;
T = 100;a=0.95;

% �˻�
k=1;
for i=1:200
    tSave(k) = T;
    k=k+1;
    T = T*a;
end

% �ػ���˻�
for i=1:10
    T = 10;
    for j=1:20
        tSave(k) =T;
        k=k+1;
        T=T*0.7;
    end
end
figure1 = figure('color',[1 1 1]);
plot(tSave,'r');
xlabel("steps");ylabel("T/^oC");
print(figure1,'-dpng','-r300','./png/T.png');
