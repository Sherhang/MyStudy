function [ Plan ] = decode( plan,orderm,ordern)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[numofplan,~]=size(plan);
[~,numofm]=size(orderm);[~,numofn]=size(ordern);
Plan=[];
for k=1:numofplan
  Plan(k,1,:)=ordern;
  Plan(k,2,:)=zeros(1,numofn);
  orderm2=orderm;
  if numofm<numofn
    orderm2(numofm+1:max(numofm,numofn))=zeros(1,abs(numofm-numofn));
  end
  for i=1:numofn
    Plan(k,2,i)=orderm2(plan(k,i));
  end
  
  
end

