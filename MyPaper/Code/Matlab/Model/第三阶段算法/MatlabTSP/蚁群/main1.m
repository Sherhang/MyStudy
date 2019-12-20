 clear
clc
C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];%城市的坐标矩阵1.5378E4模拟退火算法解
NC_max=200;
m=30;
Alpha=0.1;
Beta=10;
Rho=0.5;
Q=100;
[R_best,L_best,L_ave,Shortest_Route,Shortest_Length]=ACATSP(C,NC_max,m,Alpha,Beta,Rho,Q)

figure(1)
P=C;N=size(C,1);minplan=Shortest_Route;
plot(P(:,1),P(:,2),'ro');
hold on
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)]);
end
 line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)]);
 for i=1:N
    str=sprintf('%d',i);
   text(P(i,1)+0.3,P(i,2),str);
 end