% 高斯核函数
x = -5:0.01:5;
y = gauss(x,0,1);
figure1 = figure('color',[ 1 1 1]);
plot(x,y,'r');
legend("\sigma = 1");
xlabel("x");ylabel("f");
print(figure1,'-dpng','-r300','./png/gauss1.png');   % 保存到工作目录下

figure2 = figure('color',[ 1 1 1]);
x = -5:0.01:5;
y = gauss(x,0,2);
plot(x,y,'r');
legend("\sigma = 2");
xlabel("x");ylabel("f");
print(figure2,'-dpng','-r300','./png/gauss2.png');   % 保存到工作目录下



function f = gauss(x,y,sigma)
% 一维高斯核函数
f = exp(-(x-y).^2/(sigma^2));
end