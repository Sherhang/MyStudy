clc;clear;
N=100;
steps1=1000;steps2=10;

% fx(:,1)=200.*[1 2 3 4 5 6 7 1 1]';
% fy(:,1)=-200*[1 2 -1 1 4 -1  6 1 1]';
% mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
% tx(:,1)=10000+50*[4 5 7 -6 -4 -6 5 1 1]';
% ty(:,1)=10000+50*[-3 -5 6 -3 -4 8  9 1 2 ]';
for t=1:steps1
%    fx(:,t+1)=fx(:,t)+300*[1 1 1  2 3 4 4  1 2]';
%     fy(:,t+1)=fy(:,t)+300*[-3 -2  -1 1 2 3 1 2 4]';
    fx(:,t)=500000*rand(1,N)';
    fy(:,t)=500000*rand(1,N)';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
%    tx(:,t+1)=tx(:,t)+200*[4 5 6 5 6 4  4 1 2]';
%    ty(:,t+1)=ty(:,t)+200*[6 5 4 0 -1 -2 1 2 3]';
    tx(:,t)=500000*rand(1,N)';
    ty(:,t)=500000*rand(1,N)';
end
for t=1:steps2;
    %************* ��в��������˸���
    Fx=fx(:,t);
    Fy=fy(:,t);
    Mx=mx(:,t);
    My=my(:,t);
    Tx=tx(:,t);
    Ty=ty(:,t);
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
   % Val=rand(N,N);%s�������
    Val=round(100000*Val)/100000;
%     Val(find(Val>0.975))=0.975;
%     Val(find(Val<0.1))=0.1;
    val_store(:,:,t)=Val;
    
 %���ӹ滮��һ�棬�̶�̮������
    [Qplan1,EQplan1]=minAssign1(max(max(Val))-Val);
    Qplan_store1(t,:)=Qplan1;
    EQplan_store1(:,:,t)=EQplan1;
    Qmaxval1(t)=sum(sum(Val.*codeVal2codeBool(Qplan1,N)));
    EQmaxval1(t)=sum(sum(Val.*EQplan1));
%���ӹ滮�ڶ��棬���̶�̮������    
    [Qplan2,~]=minAssign(max(max(Val))-Val);
    Qmaxval2(t)=sum(sum(Val.*codeVal2codeBool(Qplan2,N)));
  
    
%���ӹ滮31�棬�̶�̮������
    [Qplan31,EQplan31]=minAssign1(max(max(Val))-Val+0.00001*rand(N,N));
    Qplan_store31(t,:)=Qplan31;
    EQplan_store31(:,:,t)=EQplan31;
    Qmaxval31(t)=sum(sum(Val.*codeVal2codeBool(Qplan31,N)));
    EQmaxval31(t)=sum(sum(Val.*EQplan31));
%���ӹ滮21�棬���̶�̮������    
    [Qplan32,~]=minAssign(max(max(Val))-Val+0.00001*rand(N,N));
    Qmaxval32(t)=sum(sum(Val.*codeVal2codeBool(Qplan32,N)));
  
    
    plan=minzp(max(max(Val))-Val);
    Bplan=codeBool2codeVal(plan,N);
    Bplan_store(t,:)=Bplan;
    Bmaxval(t)=sum(sum(Val.*plan));
    
    plan=minLzp(max(max(Val))-Val++0.00001*rand(N,N));
    Lplan=codeBool2codeVal(plan,N);
    [m,n]=size(Lplan);
    Lplan_store(t,1:n)=Lplan;
    Lmaxval(t)=sum(sum(Val.*plan));
  
end

% for t=1:steps2
%     Val=val_store(:,:,i);
%     %���ӹ滮31�棬����Ϊ�������Ź̶�̮������
%     [Qplan31,EQplan31]=minAssign1(max(max(Val))-Val+0.00001*rand(N,N));
%     Qplan_store31(t,:)=Qplan31;
%     EQplan_store31(:,:,t)=EQplan31;
%     Qmaxval31(t)=sum(sum(Val.*codeVal2codeBool(Qplan31,N)));
%     EQmaxval31(t)=sum(sum(Val.*EQplan31));
% %���ӹ滮21�棬����Ϊ�����������̶�̮������    
%     [Qplan32,~]=minAssign(max(max(Val))-Val+0.00001*rand(N,N));
%     Qmaxval32(t)=sum(sum(Val.*codeVal2codeBool(Qplan32,N)));
% end


flag0=sum(Qmaxval1>=Bmaxval);
per0=flag0/steps2


flag=sum(Qmaxval2==Bmaxval);
per=flag/steps2

flag1=sum(Qmaxval2-Bmaxval>=0);
per1=flag1/steps2

flag2=sum(Qmaxval2-EQmaxval1>=0);
per2=flag2/steps2

flag31=sum(Qmaxval31-Bmaxval>=0);
per31=flag31/steps2

flag32=sum(Qmaxval31-Bmaxval>=0);
per32=flag32/steps2


save 7.20.10.4�Ƚ�2��.mat Qmaxval1 Qmaxval31 Qmaxval32 Bmaxval Qmaxval2 Fx Fy Tx Ty Mx My Qplan1 N

figure(1);
plot((Qmaxval1-Bmaxval),'r')
hold on

plot(Qmaxval2-Bmaxval,'g:.')
hold on
legend('�̶�̮������','ģ��̮������')
% plot(EQmaxval1-Bmaxval,'b:.')
% hold on
% %legend('�̶�̮������','ģ��̮������','��������')
% 
% plot(Lmaxval-Bmaxval,'k');
% legend('�̶�̮������','ģ��̮������','��������','����Ϊ�������Թ滮ȡ��')

%legend('���ӹ滮ֵ-bintprog��������ֵ','��������ֵ-bintprog����ֵ','���Թ滮ֵ-bintprog')

figure(2)
plot(Bmaxval,'ko');
hold on 
plot(Qmaxval1,'r:.');
hold on 
plot(Qmaxval2,'b--');

legend('bintprog����ֵ','�̶�̮���������ӹ滮ֵ','ģ��̮���������ӹ滮ֵ')

figure(3)
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Fx,Fy,'b^','markersize',12);
hold on
plot(Tx,Ty,'ro','markersize',12);
for i=1:N
    h=line([Tx(i),Mx(Qplan1(i))],[Ty(i),My(Qplan1(i))]);
    hold on
    set(h,'color','g');
    
end
for i=1:N
    str=sprintf('%d',i);
   text(Tx(i),Ty(i),str);
   text(Fx(i),Fy(i),str);
end

figure(4);
plot((Qmaxval31-Bmaxval),'r')
hold on

plot(Qmaxval32-Bmaxval,'g:.')
hold on
legend('����Ϊ���ŵĹ̶�̮������','����Ϊ���ŵ�ģ��̮������')
% plot(EQmaxval31-Bmaxval,'b:.')
% hold on
% legend('�̶�̮������','ģ��̮������','��������')
