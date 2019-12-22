% ILS 数据搜索过程
file = "opt_chn144.txt";
data = read_txt(file);
% plot
figure1 = figure('color',[1 1 1]);
plot(data(:,1),'r','LineWidth',3);hold on; % 最优值
x=1:length(data(:,2));
scatter(x,data(:,2),5,'k*','LineWidth',1);hold on;
xlabel("steps");ylabel("distance/m");
legend("最优解","当前解")
print(figure1,'-dpng','-r300','./png/ILS.png')   % 保存到工作目录下
%


function f = read_txt(file)
% 读入tsp数据集。https://blog.csdn.net/u012366767/article/details/81565427
% 输入：file 文件路径/文件名 
% 输出：一个n*2的数组
% f= read_csv("./Data/a280.csv")
file = fopen(file, 'r');

f = textscan(file, '%f,%f','HeaderLines',0);% 元胞数组
% 只要坐标数据
f = cell2mat(f);
end