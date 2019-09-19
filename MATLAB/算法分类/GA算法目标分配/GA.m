t1=clock;
%GA参数
NIND=100;       %个体数目
MAXGEN=500;     %最大遗传代数
GGAP=0.9;       %代沟
trace=zeros(MAXGEN,2);       %GA性能跟踪初始值
BaseV=crtbase(15,8);
Chrom=crtbp(NIND,BaseV)+ones(NIND,15);   %初始种群
gen=0;
ObjV=targetalloc(Chrom);   %初始种群函数值
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %分配适应度值
    SelCh=select('sus',Chrom,FitnV,GGAP);   %选择 ，从Chrome中选择适应度好的到selch,有GGAP的个体被复制到下一代，总个体数不变，sus表示随机遍历抽样
    SelCh=recombin('xovdp',SelCh,0.7);    %重组，xovsp单点交叉，交叉概率0.7
    f=rep([1;8],[1,15]);% 变异边界
    SelCh=mutbga(SelCh,f); %实值变异，变异概率默认为1/个体变量数，这里是1/15
    SelCh=fix(SelCh);   %取整
    ObjVSel=targetalloc(SelCh);         %计算子代目标函数值
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %重插入，基于适应度选择。objvs是新的目标值
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


    
