function f = read_csv(file)
% ����tsp���ݼ���https://blog.csdn.net/u012366767/article/details/81565427
% ���룺file �ļ�·��/�ļ��� ./Data/att48.tsp
% �����һ��n*2������
% f= read_csv("./Data/a280.csv")
file = fopen(file, 'r');

f = textscan(file, '%f,%f,%f','HeaderLines',1);% Ԫ������
% ֻҪ��������
f = cell2mat(f);
f = f(:,2:3);

end