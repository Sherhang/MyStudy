
p=[1 3 4 5 7];
num=2;
seln=zeros(1,num);
%����Ⱥ��ѡ���������壬��Ҫ����ѡ��ͬһ������
for n=1:num
    p=p/sum(p);
    s=p(1);
    k=1;
    r=rand;  %����һ�������
    while (r>s)
        s=s+p(k);
        k=k+1;
    end
   
    seln(n)=k;
    
    p(k)=[];
    
   
end