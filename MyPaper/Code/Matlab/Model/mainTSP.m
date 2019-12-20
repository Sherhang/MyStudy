% 当main函数结束之后，运行
city = zeros(obj.numOfTargets+1,2);
city(1,:) = obj.Fighters.p(1,:) + 1000*[50, 0.5]; % 出发点
city(2:obj.numOfTargets+1,:) = obj.Targets.p;

[fTSPBest,xTSPBest] = TSPSA(city, 10000, 0.95, 0.01, 6000);
fprintf("最短路径长度为%f\n", fTSPBest);

% plot
% figure3 = figure('color',[1 1 1]);
P=city;N=obj.numOfTargets+1;minplan=xTSPBest;
pp1 = plot(P(1,1),P(1,2),'rp','MarkerFaceColor','r');hold on;
pp2 = plot(P(2:N,1),P(2:N,2),'r^','MarkerFaceColor','r');hold on;
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)],'color','k');
end
line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)],'color','k');
xlabel("x/m");ylabel("y/m");
legend([pp1,pp2],["出发点","侦查点"],'Location','northwest');
print(figure3,'-dpng','-r300','./png/Investigate.png')   % 保存到工作目录下