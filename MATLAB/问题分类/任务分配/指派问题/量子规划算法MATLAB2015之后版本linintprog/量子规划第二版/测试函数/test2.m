%����̮��
clear
clc
p=[0.15 0.6 0.25;0.5 0.1 0.2 ;0.05 0.3 0.65];N=3;

for j=1:N
    
    [row ,clo]=find(p==max(max(p)));
    m=row(1);n=clo(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
    if p(m,n)>0.6
        Msort(j)=row(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
        Tsort(j)=clo(1);
        p(Msort(j),:)=0;
        p(:,Tsort(j))=0;
    
    else 
        row1=p(m,:);clo1=p(:,n);
        [prow,pclo] = gamble( row1,clo1,m,n,N );
        Msort(j)=prow;
        Tsort(j)=pclo;
        p(Msort(j),:)=0;
        p(:,Tsort(j))=0;
    end
    
   
end
temp=sortrows([Msort',Tsort'],2);
plan=temp(:,1)'
