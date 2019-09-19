
p=[1 3 4 5 7];
num=2;
seln=zeros(1,num);
%从种群中选择两个个体，不要两次选择同一个个体
for n=1:num
    p=p/sum(p);
    s=p(1);
    k=1;
    r=rand;  %产生一个随机数
    while (r>s)
        s=s+p(k);
        k=k+1;
    end
   
    seln(n)=k;
    
    p(k)=[];
    
   
end