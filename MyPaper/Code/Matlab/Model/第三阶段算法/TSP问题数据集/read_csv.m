function f = read_csv(file)
% 读入tsp数据集。https://blog.csdn.net/u012366767/article/details/81565427
% 输入：file 文件路径/文件名 ./Data/att48.tsp
% 输出：一个n*2的数组
% f= read_csv("./Data/a280.csv")
file = fopen(file, 'r');

f = textscan(file, '%f,%f,%f','HeaderLines',1);% 元胞数组
% 只要坐标数据
f = cell2mat(f);
f = f(:,2:3);

end