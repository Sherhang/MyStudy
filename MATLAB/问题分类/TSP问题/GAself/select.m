function seln=select(p)
%ѡ��������Ⱥÿ�������ѡ���������p,���̶�,�������ŽⱣ������
num=2;
seln=zeros(1,num);
[~,pmax]=max(p);
%���ŽⱣ��
seln(1)=pmax;
p(pmax)=0;
%����Ⱥ��ѡ����������
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
    p(t)=0;%��ֹѡͬһ��r
 
end
end

