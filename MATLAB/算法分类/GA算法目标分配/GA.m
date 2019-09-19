t1=clock;
%GA����
NIND=100;       %������Ŀ
MAXGEN=500;     %����Ŵ�����
GGAP=0.9;       %����
trace=zeros(MAXGEN,2);       %GA���ܸ��ٳ�ʼֵ
BaseV=crtbase(15,8);
Chrom=crtbp(NIND,BaseV)+ones(NIND,15);   %��ʼ��Ⱥ
gen=0;
ObjV=targetalloc(Chrom);   %��ʼ��Ⱥ����ֵ
while gen<MAXGEN,
    FitnV=ranking(-ObjV);   %������Ӧ��ֵ
    SelCh=select('sus',Chrom,FitnV,GGAP);   %ѡ�� ����Chrome��ѡ����Ӧ�Ⱥõĵ�selch,��GGAP�ĸ��屻���Ƶ���һ�����ܸ��������䣬sus��ʾ�����������
    SelCh=recombin('xovdp',SelCh,0.7);    %���飬xovsp���㽻�棬�������0.7
    f=rep([1;8],[1,15]);% ����߽�
    SelCh=mutbga(SelCh,f); %ʵֵ���죬�������Ĭ��Ϊ1/�����������������1/15
    SelCh=fix(SelCh);   %ȡ��
    ObjVSel=targetalloc(SelCh);         %�����Ӵ�Ŀ�꺯��ֵ
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);  %�ز��룬������Ӧ��ѡ��objvs���µ�Ŀ��ֵ
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


    
