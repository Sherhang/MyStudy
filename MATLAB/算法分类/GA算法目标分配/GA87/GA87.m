clear;
clc;
t1=clock;
%GA参数
NIND=40;       %个体数目
MAXGEN=2000;     %最大遗传代数
GGAP=0.9;       %代沟
trace=zeros(MAXGEN,2);       %GA性能跟踪初始值
BaseV=crtbase(7,8);
Chrom=crtbp(NIND,BaseV)+ones(NIND,7);   %初始种群
gen=0;
ObjV=targetalloc(Chrom);   %初始种群函数值
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %分配适应度值
    SelCh=select('sus',Chrom,FitnV,GGAP);   %选择
    SelCh=recombin('xovsp',SelCh,0.7);    %重组
    f=rep([1;8],[1,7]);
    SelCh=mutbga(SelCh,f); 
    SelCh=fix(SelCh);   %变异
    ObjVSel=targetalloc(SelCh);         %计算子代目标函数值
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %重插入
    gen=gen+1;
    trace(gen,1)=max(ObjV);
    trace(gen,2)=sum(ObjV)/length(ObjV);
end
[Y,I]=max(ObjV); Chrom(I,:),Y            %最优解和目标函数值
t2=clock;
time=t2-t1
plot(trace(:,1),'r')
hold on
plot(trace(:,2))
grid
legend('解的变化','种群均值变化')


    
