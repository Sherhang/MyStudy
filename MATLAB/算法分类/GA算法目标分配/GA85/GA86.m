clear;
clc;
t1=clock;
%GA����
NIND=40;       %��Ⱥ����
MAXGEN=200;     %����Ŵ�����
GGAP=0.9;       %����,��ʾ����ʱ��90%�ĸ��屻���Ƶ���һ��
trace=zeros(MAXGEN,2);       %GA���ܸ��ٳ�ʼֵ
BaseV=rep(8,[1,6]); 
Chrom=crtbp(NIND,BaseV)+ones(NIND,6);   %������ʼ��Ⱥ������ֵ��Ⱥ
gen=0;
ObjV=targetalloc(Chrom);   %��ʼ��Ⱥ����ֵ
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %������Ӧ��ֵ
    SelCh=select('rws',Chrom,FitnV,GGAP);   %ѡ��
    SelCh=recombin('xovsp',SelCh,0.7);    %����
    f=rep([1;8],[1,6]);
    SelCh=mutbga(SelCh,f);                                                                                                                          
    SelCh=fix(SelCh);   %����
    ObjVSel=targetalloc(SelCh);         %�����Ӵ�Ŀ�꺯��ֵ
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %�ز���
    gen=gen+1;
    trace(gen,1)=max(ObjV);
    trace(gen,2)=sum(ObjV)/length(ObjV);
end
[Y,I]=max(ObjV); result=Chrom(I,:),Y            %���Ž��Ŀ�꺯��ֵ
t2=clock;
time=t2-t1
plot(trace(:,1),'r')
hold on
plot(trace(:,2))
grid
legend('��������','���������ֵ')
xlabel('steps');ylabel('����ֵ');
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






    
