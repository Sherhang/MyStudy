% ILS ������������
file = "opt_chn144.txt";
data = read_txt(file);
% plot
figure1 = figure('color',[1 1 1]);
plot(data(:,1),'r','LineWidth',3);hold on; % ����ֵ
x=1:length(data(:,2));
scatter(x,data(:,2),5,'k*','LineWidth',1);hold on;
xlabel("steps");ylabel("distance/m");
legend("���Ž�","��ǰ��")
print(figure1,'-dpng','-r300','./png/ILS.png')   % ���浽����Ŀ¼��
%


function f = read_txt(file)
% ����tsp���ݼ���https://blog.csdn.net/u012366767/article/details/81565427
% ���룺file �ļ�·��/�ļ��� 
% �����һ��n*2������
% f= read_csv("./Data/a280.csv")
file = fopen(file, 'r');

f = textscan(file, '%f,%f','HeaderLines',0);% Ԫ������
% ֻҪ��������
f = cell2mat(f);
end