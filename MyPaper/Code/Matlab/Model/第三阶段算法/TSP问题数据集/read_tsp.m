function f = read_tsp(file)
% ����tsp���ݼ���https://blog.csdn.net/u012366767/article/details/81565427
% ���룺file �ļ�·��/�ļ��� ./Data/att48.tsp
% �����һ��n*2������
% read_tsp("./Data/att48.tsp")
file = fopen(file, 'r');
f = textscan(file, '%f %f %f','HeaderLines',6);% Ԫ������, ����ǰ6�У��ӵ�7�п�ʼ��
% ֻҪ��������
f = cell2mat(f);
f = f(:,2:3);

end