%����
%����������pc,snew����������
function snnew=mutation(snew,pm)
 
bn=size(snew,2);
snnew=snew;
 
 %���ݱ�����ʾ����Ƿ���б������
if rand<pm
    
   c1=round(rand*(bn-2))+1;  %��[1,bn-1]��Χ���������һ������λ
   c2=round(rand*(bn-2))+1;
   chb1=min(c1,c2);
   chb2=max(c1,c2);
   x=snew(chb1:chb2);
   snnew(chb1:chb2)=fliplr(x);%������죬2�任
end
end

