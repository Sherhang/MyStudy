%变异
%输入变异概率pc,snew个体行向量
function snnew=mutation(snew,pm)
 
bn=size(snew,2);
snnew=snew;
 
 %根据变异概率决定是否进行变异操作
if rand<pm
    
   c1=round(rand*(bn-2))+1;  %在[1,bn-1]范围内随机产生一个变异位
   c2=round(rand*(bn-2))+1;
   chb1=min(c1,c2);
   chb2=max(c1,c2);
   x=snew(chb1:chb2);
   snnew(chb1:chb2)=fliplr(x);%倒序变异，2变换
end
end

