% 几种指派问题算法代码的时间数据
% plot

figure1 = figure('color',[1 1 1]); % 加上分支定界法的结果
plot(TimePSA,'r','MarkerIndices',[1 5 10]);hold on;
plot(TimeRPSA);hold on;
plot(TimeKM*5);hold on;
plot(TimeAuction);hold on;
plot(TimePart,'k');hold on;  % 分支定界法BB
axis([0 200 0 60]);
xlabel("N");ylabel("time/s");
legend("PSA","IPSA","KM","AA","BB");
print(figure1,'-dpng','-r300','./png/TimeOfC4_1.png')   % 保存到工作目录下

figure2 = figure('color',[1 1 1]); % 无分支定界法的结果
plot(time_base);hold on; % PSA
plot(time_q);hold on; % RPSA
plot(time_munkres*5,'b');hold on;
plot(time_auction);hold on;
xlabel("N");ylabel("time/s");
axis([0 500 0 5]);
legend("PSA","IPSA","KM","AA");
print(figure2,'-dpng','-r300','./png/TimeOfC4_2.png')   % 保存到工作目录下

% 函数拟合
figure3 = figure('color', [1 1 1]);
% auction算法
x =1:500;y=time_auction;
p = polyfit(x,y,2);
y = p(1)*x.^2 + p(2).*x + p(3);% 拟合函数
scatter(x,time_auction,10,'k+','LineWidth',1);hold on;
plot(x,y);hold on;
xlabel("N");ylabel("time/s");
print(figure3,'-dpng','-r300','./png/TimeAuction.png')   % 保存到工作目录下

% % KM算法
% x =1:500;y=time_auction;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% 拟合函数
% scatter(x,time_munkres,10,'r*','LineWidth',1);hold on;
% plot(x,y);hold on;
% % PSA算法
% x =1:500;y=time_auction;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% 拟合函数
% scatter(x,time_base,10,'bo','LineWidth',1);hold on;
% plot(x,y);hold on;
% % RPSA算法
% x =1:500;y=time_q;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% 拟合函数
% scatter(x,time_q,10,'k+','LineWidth',1);hold on;
% plot(x,y);hold on;
% 
% 
