function [ Qplan_unique,EQplan,f1,f2] = minAssign_mplan( Val,M)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%  Val��С������ϵ������M�Ŷ�����������MΪϣ���õ������ŷ�����Ŀ�����ֵ
 % Qplan_unique���ظ����ŷ���,Qmaxval�����з��������庯��ֵ,f������Ӧ����ֵ
 [~,N]=size(Val);
 %q=mean(mean(Val))/10^4;%��������������Ϊ��������С4��
 q=0.000001;%��������������Ϊ��������С5��
 
for i=1:M  %���Ŵ��� 
   [Qplan,EQplan]=minAssign_noise(Val+q*rand(N,N));
    Qplan_store(i,:)=Qplan;
    Qminval(i)=sum(sum(Val.*codeVal2codeBool(Qplan,N)));%ʵ�ʼ������������㷨�������ټ�������ʵ���ϼ�����ҲûʲôӰ��    
end
Qplan_unique=unique(Qplan_store,'rows');
f1=min(Qminval);
f2=max(Qminval);

end

