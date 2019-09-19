clear;
clc;
t1=clock;
%GA����
NIND=40;       %������Ŀ
MAXGEN=2000;     %����Ŵ�����
GGAP=0.9;       %����
trace=zeros(MAXGEN,2);       %GA���ܸ��ٳ�ʼֵ
BaseV=crtbase(7,8);
Chrom=crtbp(NIND,BaseV)+ones(NIND,7);   %��ʼ��Ⱥ
gen=0;
ObjV=targetalloc(Chrom);   %��ʼ��Ⱥ����ֵ
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %������Ӧ��ֵ
    SelCh=select('sus',Chrom,FitnV,GGAP);   %ѡ��
    SelCh=recombin('xovsp',SelCh,0.7);    %����
    f=rep([1;8],[1,7]);
    SelCh=mutbga(SelCh,f); 
    SelCh=fix(SelCh);   %����
    ObjVSel=targetalloc(SelCh);         %�����Ӵ�Ŀ�꺯��ֵ
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %�ز���
    gen=gen+1;
    trace(gen,1)=max(ObjV);
    trace(gen,2)=sum(ObjV)/length(ObjV);
end
[Y,I]=max(ObjV); Chrom(I,:),Y            %���Ž��Ŀ�꺯��ֵ
t2=clock;
time=t2-t1
plot(trace(:,1),'r')
hold on
plot(trace(:,2))
grid
legend('��ı仯','��Ⱥ��ֵ�仯')


    
