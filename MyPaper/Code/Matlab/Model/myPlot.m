%% --------plot----------
%-------------模型图-------------
figure1 = figure('color',[1 1 1]);
% 用来legend
x = fightersSave.p(:,1,1); % 第一架载机
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;

x = targetsSave.p(1:stepFighters,1,1);
y = targetsSave.p(1:stepFighters,1,2);
p3 = plot(x,y,'color','g');hold on;

% 载机
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
end

% 目标
for i=1:obj.numOfTargets
    x = targetsSave.p(1:stepFighters,i,1);
    y = targetsSave.p(1:stepFighters,i,2);
    plot(x,y,'color','g');hold on;
end
% 箭头
% 载机初始时刻位置的方向
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;

% 目标初始时刻的速度方向
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;
legend([p1,p3],["载机","目标"],'Location','northwest');
xlabel("x/m");ylabel("y/m");
print(figure1,'-dpng','-r300','./png/Process1.png')   % 保存到工作目录下

%% --------plot----------
%-------------模型图-------------
figure2 = figure('color',[1 1 1]);
% 用来legend
x = fightersSave.p(:,1,1); % 第一架载机
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;
x = missilesSave.p(:,1,1);
y = missilesSave.p(:,1,2);
p2 = plot(x,y,'b');  hold on;
x = targetsSave.p(:,1,1);
y = targetsSave.p(:,1,2);
p3 = plot(x,y,'color','g');hold on;

% 载机
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
end
% 导弹
for i=1:obj.numOfMissiles
    x = missilesSave.p(:,i,1);
    y = missilesSave.p(:,i,2);
    plot(x,y,'b');hold on;
end
% 目标
for i=1:obj.numOfTargets
    x = targetsSave.p(:,i,1);
    y = targetsSave.p(:,i,2);
    plot(x,y,'color','g');hold on;
end
% 箭头
% 载机初始时刻位置的方向
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;
% 导弹初始时刻位置的方向
x = missilesSave.p(1,:,1);
y = missilesSave.p(1,:,2);
quiver(x',y', cos(missilesSave.angle(1,:))',sin(missilesSave.angle(1,:))',0.3,'color','b');
hold on;
% 目标初始时刻的速度方向
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;

legend([p1,p2,p3],["载机","导弹","目标"],'Location','northwest');
xlabel("x/m");ylabel("y/m");
print(figure2,'-dpng','-r300','./png/Process2.png')   % 保存到工作目录下