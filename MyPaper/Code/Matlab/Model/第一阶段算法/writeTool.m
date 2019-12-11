% 录数据脚本，存为md的表格形式
% file = fopen('table.txt','w');
%% GA 的 35 种算法，先加载数据, 然后修改per
% algoCross=["PMX","OX1","OX2","CX","PBX"];
% algoMutate=["EM","DM","IM","SIM","IVM","SM","LM"];
% accF = 0.543504567006814;

% per = "SAGA";
% for i=1:5
%     for j=1:7
%         algo = per+"_"+algoCross(i)+"_"+algoMutate(j);
%         fprintf(file,"| "+algo+"  |  ");
%         fprintf(file,'%.5f',AlgBestSave(i,j));  % 最优值
%         fprintf(file,"  |  ");
%         fprintf(file,'%.5f', (100-AlgBestSave(i,j)/accF*100)); %误差
%         fprintf(file, "%%");
%         fprintf(file, "  |  ");
%         fprintf(file, '%d',AlgMinSteps(i,j));
%         fprintf(file,"  |  ");
%         fprintf(file,'%.3f',AlgTime(i,j));
%         fprintf(file,"  |  \n");
%     end
% end

% SAA 算法
%-----结果保存到文件----
file = fopen('table.txt','w');
algoMutate=["EM","DM","IM","SIM","IVM","SM","LM"];
accF = 0.543504567006814;
for j=1:7
    algo = "SAA"+"_"+algoMutate(j);
    fprintf(file,"| "+algo+"  |  ");
    fprintf(file,'%.5f',fBestSAA(j));  % 最优值
    fprintf(file,"  |  ");
    fprintf(file,'%.5f', (100-fBestSAA(j)/accF*100)); %误差
    fprintf(file, "%%");
    fprintf(file, "  |  ");
    fprintf(file, '%d',minStepsSAA(j));
    fprintf(file,"  |  ");
    fprintf(file,'%.3f',timeSAA(j));
    fprintf(file,"  |  \n");
end
        