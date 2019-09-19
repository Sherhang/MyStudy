function seln=select(p)
%选择，输入种群每个个体的选择概率向量p,轮盘赌,加入最优解保护策略
num=2;
seln=zeros(1,num);
[~,pmax]=max(p);
%最优解保护
seln(1)=pmax;
p(pmax)=0;
%从种群中选择两个个体
for n=2:num
    r=rand;t=1;
    p=p/sum(p);
    s=p(1);
    while(1)
       if r<=s
           break;
       end
       t=t+1;
       s=s+p(t);
    end
    seln(n)=t;
    p(t)=0;%防止选同一个r
 
end
end

