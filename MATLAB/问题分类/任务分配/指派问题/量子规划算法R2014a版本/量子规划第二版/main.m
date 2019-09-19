clc;clear;
N=80;
steps1=1000;steps2=100;

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
    val_store(:,:,t)=Val;
    
%     [Aplan,gains,c]=all2all(Val,N);
%     simpleVal(t)=mean(gains);
%     Amaxval(t)=sum(sum(Val.*codeVal2codeBool(Aplan,N)));

    [Qplan,EQplan]=minAssign(max(max(Val))-Val);
    Qplan_store(t,:)=Qplan;
    EQplan_store(:,:,t)=EQplan;
    Qmaxval(t)=sum(sum(Val.*codeVal2codeBool(Qplan,N)));
    EQmaxval(t)=sum(sum(Val.*EQplan));
    
    plan=minzp(max(max(Val))-Val);
    Bplan=codeBool2codeVal(plan,N);
    Bplan_store(t,:)=Bplan;
    Bmaxval(t)=sum(sum(Val.*plan));
    
    plan=minLzp(max(max(Val))-Val);
    Lplan=codeBool2codeVal(plan,N);
    [m,n]=size(Lplan);
    Lplan_store(t,1:n)=Lplan;
    Lmaxval(t)=sum(sum(Val.*plan));
    
    
    
    
end


flag=sum(Qmaxval==Bmaxval);
per=flag/steps2

figure(1);
plot((Qmaxval-Bmaxval),'r')
hold on
plot(EQmaxval-Bmaxval,'b')
hold on
legend('���ӹ滮ֵ-bintprog����ֵ','��������ֵ-bintprog����ֵ')

%  plot(Lmaxval-Bmaxval,'g')
%  hold on
%legend('���ӹ滮ֵ-bintprog��������ֵ','��������ֵ-bintprog����ֵ','���Թ滮ֵ-bintprog')

figure(2)
plot(Bmaxval,'bo');
hold on 
plot(Qmaxval,'r');
legend('bintprog����ֵ','���ӹ滮ֵ')

figure(3)
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Fx,Fy,'b^','markersize',12);
hold on
plot(Tx,Ty,'ro','markersize',12);
for i=1:N
    h=line([Tx(i),Mx(Qplan(i))],[Ty(i),My(Qplan(i))]);
    hold on
    set(h,'color','g');
    
end
for i=1:N
    str=sprintf('%d',i);
   text(Tx(i),Ty(i),str);
   text(Fx(i),Fy(i),str);
end




    