%标准Grover算法成功概率与π/2相移算法的成功概率对比
clear all;
close all;
%标记态与状态总数的比值
t = 0.001:0.001:1;
%标准Grover算法迭代步数
r = round(acos(sqrt(t))./(2*asin(sqrt(t))));
%标准Grover算法的成功概率
P = sin((2*r+1).*asin(sqrt(t))).^2;
%当t > 1/3且旋转相位为π/2时，经过一步迭代后算法的成功概率
P1 = 4*t.^3-8*t.^2 + 5*t;
plot(t, P,'r', t, P1,'b')
legend("标准Grover算法","一步迭代");
grid on