% 数据转化为csv格式
%% chn144
Data = ["att48","a280","ali535","rl1304","usa13509"];

for k = 1:length(Data)
    data = Data(k)
    file = fopen(data+".csv", 'w');
    m = read_tsp("Data/"+data+".tsp");
    if data=="ali535"
        m = 100*m;
    end
    fprintf(file,"city,x,y\n");
    n = size(m,1);
    for i=1:n
        format long g
        fprintf(file,"%d,%d,%d\n",i, m(i,1),m(i,2));
    end
end