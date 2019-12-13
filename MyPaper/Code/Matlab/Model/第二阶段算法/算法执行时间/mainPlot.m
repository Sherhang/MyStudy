% ����ָ�������㷨�����ʱ������
% plot

figure1 = figure('color',[1 1 1]); % ���Ϸ�֧���編�Ľ��
plot(TimePSA,'r','MarkerIndices',[1 5 10]);hold on;
plot(TimeRPSA);hold on;
plot(TimeKM*5);hold on;
plot(TimeAuction);hold on;
plot(TimePart,'k');hold on;  % ��֧���編BB
axis([0 200 0 60]);
xlabel("N");ylabel("time/s");
legend("PSA","IPSA","KM","AA","BB");
print(figure1,'-dpng','-r300','./png/TimeOfC4_1.png')   % ���浽����Ŀ¼��

figure2 = figure('color',[1 1 1]); % �޷�֧���編�Ľ��
plot(time_base);hold on; % PSA
plot(time_q);hold on; % RPSA
plot(time_munkres*5,'b');hold on;
plot(time_auction);hold on;
xlabel("N");ylabel("time/s");
axis([0 500 0 5]);
legend("PSA","IPSA","KM","AA");
print(figure2,'-dpng','-r300','./png/TimeOfC4_2.png')   % ���浽����Ŀ¼��

% �������
figure3 = figure('color', [1 1 1]);
% auction�㷨
x =1:500;y=time_auction;
p = polyfit(x,y,2);
y = p(1)*x.^2 + p(2).*x + p(3);% ��Ϻ���
scatter(x,time_auction,10,'k+','LineWidth',1);hold on;
plot(x,y);hold on;
xlabel("N");ylabel("time/s");
print(figure3,'-dpng','-r300','./png/TimeAuction.png')   % ���浽����Ŀ¼��

% % KM�㷨
% x =1:500;y=time_auction;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% ��Ϻ���
% scatter(x,time_munkres,10,'r*','LineWidth',1);hold on;
% plot(x,y);hold on;
% % PSA�㷨
% x =1:500;y=time_auction;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% ��Ϻ���
% scatter(x,time_base,10,'bo','LineWidth',1);hold on;
% plot(x,y);hold on;
% % RPSA�㷨
% x =1:500;y=time_q;
% p = polyfit(x,y,2);
% y = p(1)*x.^2 + p(2).*x + p(3);% ��Ϻ���
% scatter(x,time_q,10,'k+','LineWidth',1);hold on;
% plot(x,y);hold on;
% 
% 
