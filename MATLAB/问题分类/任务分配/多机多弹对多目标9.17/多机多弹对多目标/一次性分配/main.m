%*****多载机带多枚弹对多目标，非平衡指派问题
%加入惩罚项使得用不同载机协同攻击单个目标


clear;clc;
mNum=[2 2 2 2 2 2 ];
[~,m]=size(mNum);
nV=diag([1,3 1 1 ]);
[~,n]=size(nV);
Pm=300*rand(m,2);Pn=300+300*rand(n,2);
Vm=ones(1,m)*3;Vn=ones(1,n)*2.5;
Am=round(rand(1,m)*1000);An=[1:n]*100;

Pm(:,2)=100*ones(m,1);Pn(:,2)=200*ones(n,1);
%[orderm,ordern,Val]=model(m,mNum,n,nV,Pm,Pn);
[orderm,ordern,Val,V0]=model2(m,mNum,n,nV,Pm,Pn,Vm,Vn,Am,An)
[~,numofm]=size(orderm);[~,numofn]=size(ordern);
[plan_unique,~,fout,~] = minAssign( max(max(Val))-Val,max(numofm,numofn));


 %解码
  Plan=ordern;
  Plan(2,:)=zeros(1,numofn);
  orderm2=orderm;
if numofm<numofn
    orderm2(numofm+1:max(numofm,numofn))=zeros(1,abs(numofm-numofn));
end
% [l,~]=size(plan_unique);
% k=floor(l*rand())+1;
for i=1:numofn
    Plan(2,i)=orderm2(plan_unique(1,i));
end
Plan

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
quiver(Pm(:,1)',Pm(:,2)', cos(deg2rad(Am)), sin(deg2rad(Am)),0.4,'color','r');
quiver(Pn(:,1)',Pn(:,2)', cos(deg2rad(An)), sin(deg2rad(An)),0.4','color','b');
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
