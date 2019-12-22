% 算法不同数据集数据
Datas = ["att48", "chn144", "a280", "ali535", "rl1304"];
file = fopen("data.log",'w');
for kx=1:length(Datas)
    data = "Data/"+Datas(kx)+".csv"
    city = read_csv(data);
    mainSAA
    fprintf(file,"| "+Datas(kx)+" | ");
    fprintf(file,'%.5f',E_best);
    fprintf(file," | ");
    time = toc;
    fprintf(file,num2str(time)+" |\n");
    
end