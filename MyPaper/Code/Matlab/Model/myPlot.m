%% --------plot----------
%-------------ģ��ͼ-------------
figure1 = figure('color',[1 1 1]);
% ����legend
x = fightersSave.p(:,1,1); % ��һ���ػ�
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;

x = targetsSave.p(1:stepFighters,1,1);
y = targetsSave.p(1:stepFighters,1,2);
p3 = plot(x,y,'color','g');hold on;

% �ػ�
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
end

% Ŀ��
for i=1:obj.numOfTargets
    x = targetsSave.p(1:stepFighters,i,1);
    y = targetsSave.p(1:stepFighters,i,2);
    plot(x,y,'color','g');hold on;
end
% ��ͷ
% �ػ���ʼʱ��λ�õķ���
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;

% Ŀ���ʼʱ�̵��ٶȷ���
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;
legend([p1,p3],["�ػ�","Ŀ��"],'Location','northwest');
xlabel("x/m");ylabel("y/m");
print(figure1,'-dpng','-r300','./png/Process1.png')   % ���浽����Ŀ¼��

%% --------plot----------
%-------------ģ��ͼ-------------
figure2 = figure('color',[1 1 1]);
% ����legend
x = fightersSave.p(:,1,1); % ��һ���ػ�
y = fightersSave.p(:,1,2);
p1 = plot(x,y,'r');  hold on;
x = missilesSave.p(:,1,1);
y = missilesSave.p(:,1,2);
p2 = plot(x,y,'b');  hold on;
x = targetsSave.p(:,1,1);
y = targetsSave.p(:,1,2);
p3 = plot(x,y,'color','g');hold on;

% �ػ�
for i=1:obj.numOfFighters
    x = fightersSave.p(:,i,1);
    y = fightersSave.p(:,i,2);
    plot(x,y,'r');  hold on;
    hold on;
end
% ����
for i=1:obj.numOfMissiles
    x = missilesSave.p(:,i,1);
    y = missilesSave.p(:,i,2);
    plot(x,y,'b');hold on;
end
% Ŀ��
for i=1:obj.numOfTargets
    x = targetsSave.p(:,i,1);
    y = targetsSave.p(:,i,2);
    plot(x,y,'color','g');hold on;
end
% ��ͷ
% �ػ���ʼʱ��λ�õķ���
x = fightersSave.p(1,:,1);
y = fightersSave.p(1,:,2);
quiver(x',y', cos(fightersSave.angle(1,:))',sin(fightersSave.angle(1,:))',0.3,'color','r');
hold on;
% ������ʼʱ��λ�õķ���
x = missilesSave.p(1,:,1);
y = missilesSave.p(1,:,2);
quiver(x',y', cos(missilesSave.angle(1,:))',sin(missilesSave.angle(1,:))',0.3,'color','b');
hold on;
% Ŀ���ʼʱ�̵��ٶȷ���
x = targetsSave.p(1,:,1);
y = targetsSave.p(1,:,2);
quiver(x',y', cos(targetsSave.angle(1,:))',sin(targetsSave.angle(1,:))',0.3,'color','g');
hold on;

legend([p1,p2,p3],["�ػ�","����","Ŀ��"],'Location','northwest');
xlabel("x/m");ylabel("y/m");
print(figure2,'-dpng','-r300','./png/Process2.png')   % ���浽����Ŀ¼��