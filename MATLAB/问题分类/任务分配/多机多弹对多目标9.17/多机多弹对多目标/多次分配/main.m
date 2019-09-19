%*****多载机带多枚弹对多目标，非平衡指派问题


clear;clc;
mNum=[2 3 2 2 1 2 2 2];
[~,m]=size(mNum);
nV=diag([1,1,1,1,2,1,1,1,1,1,2 ,1,1,1,1]);
[~,n]=size(nV);
Pm=20*rand(m,2);Pn=20*rand(n,2);
%Pm(:,2)=ones(m,1);Pn(:,2)=20*ones(n,1);
[orderm,ordern,V01,Val]=model(m,mNum,n,nV,Pm,Pn);
[numofm,numofn]=size(V01);
[ Plan ]=maxAssign( V01 );


 
figure%方案图
set(gcf,'color','w');
plot(Pm(:,1),Pm(:,2),'b^','markersize',12);
hold on
plot(Pn(:,1),Pn(:,2),'ro','markersize',12);
legend('载机','目标');
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Pm(:,1),Pm(:,2),'b^','markersize',12);
hold on
plot(Pn(:,1),Pn(:,2),'ro','markersize',12);
for i=1:numofn
    if(Plan(2,i)~=0)
        h=line([Pn(ordern(i),1),Pm(Plan(2,i),1)],[Pn(ordern(i),2),Pm(Plan(2,i),2)]);
        hold on
        set(h,'color','g');
    end  
end

for i=1:n
    str=sprintf('%d',i);
   text(Pn(i,1),Pn(i,2),str);
end
for i=1:m
    str=sprintf('%d',i);
   text(Pm(i,1),Pm(i,2),str);
end
