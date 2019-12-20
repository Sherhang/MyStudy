function f = read_tsp(file)
% 读入tsp数据集。https://blog.csdn.net/u012366767/article/details/81565427
% 输入：file 文件路径/文件名 ./Data/att48.tsp
% 输出：一个n*2的数组
% read_tsp("./Data/att48.tsp")
file = fopen(file, 'r');
f = textscan(file, '%f %f %f','HeaderLines',6);% 元胞数组, 跳过前6行，从第7行开始读
% 只要坐标数据
f = cell2mat(f);
f = f(:,2:3);

end