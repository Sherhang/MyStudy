function [ Qplan_unique,f] = minAssign_mplan( Val,M)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%  Val��С������ϵ������M����������MΪϣ���õ������ŷ�����Ŀ�����ֵ
 % Qplan_unique���ظ����ŷ���,Qmaxval�����з��������庯��ֵ,f������Ӧ����ֵ
 [~,N]=size(Val);
 q=mean(mean(Val))/10^4;%��������������Ϊ��������С4��
 %q=10;%��������������Ϊ��������С5��
 
for i=1:M  %�������� 
   [Qplan,~]=minAssign(Val+q*rand(N,N));
    Qplan_store(i,:)=Qplan;
    Qminval(i)=sum(sum(Val.*codeVal2codeBool(Qplan,N)));
    
end
Qplan_unique=unique(Qplan_store,'rows');
f=max(Qminval);

end

