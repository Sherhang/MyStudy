%clc;clear;
% N=10;
% %************* ��в��������˸���
%     Fx=1000000*rand(1,N)';
%     Fy=1000000*rand(1,N)';
%    
%     Tx=1000000*rand(1,N)';
%     Ty=1000000*rand(1,N)';
%     pro=f_probility(Fx,Fy,Tx,Ty,N);
%     thr=f_threat(Fx,Fy,Tx,Ty,N);
%     thr1=max(thr);
%     thr=repmat(thr1,N,1);
%     Val=pro.*thr;
%   % Val=rand(N,N);%s�������
%     Val=round(10000*Val)/10000;%����С��5λ
%     V01=Val/max(max(Val));%�����׼��0-1��Χ
% %   Val(find(Val>0.975))=0.975;  %��Ϊ����̶�̮����������������
% %   Val(find(Val<0.1))=0.1;
% % ����������
% for i=1:N
%     for j=1:N
%        D(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
%     end
% end
% d01=D/max(max(D));
% 

[Qplan_unique,EQplan,Qminval,Qbad] = minAssign_mplan( 1-V01,1);
[Bplan,Bminval]=minBzp(1-V01);
[Bminval,Qminval,Qbad,Qminval-Bminval]



figure('color',[1 1 1]);

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

figure(3)%ϵ�������ܶ�ͼ
V02=(Val-min(min(Val)))/(max(max(Val))-min(min(Val)));
for i=1:N
    for j=1:N
        x=i+0.3*(randn(1,round(V02(i,j)*500)));%����������
        y=j+0.3*(randn(1,round(V02(i,j)*500)));
        plot(x,y,'b.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
pause(1)

figure(4)%������ͼ
set(gcf,'color','w');
%figure('color',[1 1 1]);

for i=1:N
    for j=1:N
        x=i+0.4*(randn(1,round(EQplan(i,j)*1000)));%����������
        y=j+0.4*(randn(1,round(EQplan(i,j)*1000)));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
grid on