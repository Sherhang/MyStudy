%******测试单个粒子的准确率
clear
clc
n=30;
p=zeros(1,n);
p(1)=1;
for N=2:n
    main;
    p(N)=per;
    
    clearvars -EXCEPT p
   
end
plot(p,'bo');
hold on
x=1:30                                                                                      
y=polyfit(x,p,6);
Y=polyval(y,x);
plot(x,Y,'r')
xlabel('问题规模');
ylabel('单个体搜索概率');
legend('搜索概率','拟合曲线');

