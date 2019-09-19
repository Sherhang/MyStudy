clear;
clc;
t1=clock;
%GA参数
NIND=40;       %种群数量
MAXGEN=200;     %最大遗传代数
GGAP=0.9;       %代沟,表示复制时有90%的个体被复制到下一代
trace=zeros(MAXGEN,2);       %GA性能跟踪初始值
BaseV=rep(8,[1,6]); 
Chrom=crtbp(NIND,BaseV)+ones(NIND,6);   %创建初始种群，整数值种群
gen=0;
ObjV=targetalloc(Chrom);   %初始种群函数值
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %分配适应度值
    SelCh=select('rws',Chrom,FitnV,GGAP);   %选择
    SelCh=recombin('xovsp',SelCh,0.7);    %重组
    f=rep([1;8],[1,6]);
    SelCh=mutbga(SelCh,f);                                                                                                                          
    SelCh=fix(SelCh);   %变异
    ObjVSel=targetalloc(SelCh);         %计算子代目标函数值
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %重插入
    gen=gen+1;
    trace(gen,1)=max(ObjV);
    trace(gen,2)=sum(ObjV)/length(ObjV);
end
[Y,I]=max(ObjV); result=Chrom(I,:),Y            %最优解和目标函数值
t2=clock;
time=t2-t1
plot(trace(:,1),'r')
hold on
plot(trace(:,2))
grid
legend('攻击收益','攻击收益均值')
xlabel('steps');ylabel('收益值');
figure
textX=[1 1 1 1 1 1 ];
textY=[1:6];
plot(textX,textY,'or');
TEXT={'T1','T2','T3','T4','T5','T6'};
hold on;
text(textX+0.02,textY+0.02,TEXT);
textSX=[0 0 0 0 0 0 0 0 ];
textSY=[1:8];
plot(textSX,textSY,'or');
TEXTS={'S1','S2','S3','S4','S5','S6','S7','S8'};
text(textSX+0.02,textSY+0.02,TEXTS);
hold on;
for t=1:6
  line ([textX(t) textSX(t)],[textY(t) textSY(result(t))],'Color','b','LineWidth',2);
end
line ([textX(1) textSX(1)],[textY(1) 1],'Color','b','LineWidth',2);
line ([textX(2) textSX(6)],[textY(2) 6],'Color','b','LineWidth',2);






    
