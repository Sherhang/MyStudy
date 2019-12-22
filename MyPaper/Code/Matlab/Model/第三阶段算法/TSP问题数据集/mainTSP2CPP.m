% 数据转化为c++代码的数据
%% chn144
file = fopen('chn144.cpp', 'w');
m = read_csv("Data/china.csv");
fprintf(file,"city,x,y\n");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
end
fprintf(file,"{%d,%d}};", m(n,1),m(n,2));

%% att48
file = fopen('att48.cpp', 'w');
m = read_tsp("Data/att48.tsp");
fprintf(file,"CITIES berlin52[CITY_SIZE] = {");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
    if rem(i,50) == 0
        fprintf(file,"\n");
    end
end
fprintf(file,"{%f,%f}};", m(n,1),m(n,2));

%% usa13509
file = fopen('usa13509.cpp', 'w');
m = read_tsp("Data/usa13509.tsp");
fprintf(file,"CITIES berlin52[CITY_SIZE] = {");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
    if rem(i,50) == 0
        fprintf(file,"\n");
    end
end
fprintf(file,"{%f,%f}};", m(n,1),m(n,2));
%% ali535
file = fopen('ali535.cpp', 'w');
m = read_tsp("Data/ali535.tsp");
m = 100*m;
fprintf(file,"CITIES berlin52[CITY_SIZE] = {");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
    if rem(i,50) == 0
        fprintf(file,"\n");
    end
end
fprintf(file,"{%f,%f}};", m(n,1),m(n,2));

%% rl1304
file = fopen('rl304.cpp', 'w');
m = read_tsp("Data/rl1304.tsp");
fprintf(file,"CITIES berlin52[CITY_SIZE] = {");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
    if rem(i,50) == 0
        fprintf(file,"\n");
    end
end
fprintf(file,"{%f,%f}};", m(n,1),m(n,2));
%% a280
file = fopen('a280.cpp', 'w');
m = read_tsp("Data/a280.tsp");
fprintf(file,"CITIES berlin52[CITY_SIZE] = {");
n = size(m,1);
for i=1:n-1
    fprintf(file,"{%d,%d},", m(i,1),m(i,2));
    if rem(i,50) == 0
        fprintf(file,"\n");
    end
end
fprintf(file,"{%f,%f}};", m(n,1),m(n,2));