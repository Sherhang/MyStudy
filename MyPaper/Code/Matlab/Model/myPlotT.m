% 模拟退火的温度变化
clear;clc;
T = 100;a=0.95;

% 退火
k=1;
for i=1:200
    tSave(k) = T;
    k=k+1;
    T = T*a;
end

% 回火和退火
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
