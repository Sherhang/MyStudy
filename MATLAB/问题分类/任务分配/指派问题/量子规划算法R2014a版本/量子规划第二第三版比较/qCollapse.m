function [ plan,count ] = qCollapse (p,N)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
pmax=0.7;%��ֵ
count=0;%�Ż����ã���count==nʱֱ�ӽ���һ�β���
for j=1:N
    
    [row ,clo]=find(p==max(max(p)));
    m=row(1);n=clo(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
    if p(m,n)>pmax
        Msort(j)=row(1);% ��һ����Ϊ�˷�ֹ�����������ֵ��ֻҪ��һ��
        Tsort(j)=clo(1);
        p(Msort(j),:)=0;
        p(:,Tsort(j))=0;
        count=count+1;
    
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
plan=temp(:,1)';

end

