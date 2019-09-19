clc;clear;
N=50;
%************* 威胁矩阵与毁伤概率
    Fx=500000*rand(1,N)';
    Fy=500000*rand(1,N)';
   
    Tx=500000*rand(1,N)';
    Ty=500000*rand(1,N)';
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
  % Val=rand(N,N);%s随机测试
    Val=round(10000*Val)/10000;%保留小数位
%   Val(find(Val>0.975))=0.975;  %人为构造固定坍缩方案会出错的问题
%   Val(find(Val<0.1))=0.1;
% 计算距离矩阵
for i=1:N
    for j=1:N
       D(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end


D=round(D/500)*500;
[Qplan_unique,Qminval] = minAssign( D);
[Bplan,Bminval]=minBzp(D);
Bminval,Qminval,Qminval-Bminval



figure(2)
Qplan=Qplan_unique(1,:);
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Fx,Fy,'b^','markersize',12);
hold on
plot(Tx,Ty,'ro','markersize',12);
for i=1:N
    h=line([Tx(i),Fx(Qplan(i))],[Ty(i),Fy(Qplan(i))]);
    hold on
    set(h,'color','g');
    
end
for i=1:N
    str=sprintf('%d',i);
   text(Tx(i),Ty(i),str);
   text(Fx(i),Fy(i),str);
end

% [BDplan,BDminval]=minBzp( max(max(Val))-Val);
% figure(2)
% 
% % scrsz = get(0,'ScreenSize');
% % set(gcf,'Position',scrsz);
% plot(Fx,Fy,'b^','markersize',12);
% hold on
% plot(Tx,Ty,'ro','markersize',12);
% for i=1:N
%     h=line([Tx(i),Fx(BDplan(i))],[Ty(i),Fy(BDplan(i))]);
%     hold on
%     set(h,'color','g');
%     
% end
% for i=1:N
%     str=sprintf('%d',i);
%    text(Tx(i),Ty(i),str);
%    text(Fx(i),Fy(i),str);
% end