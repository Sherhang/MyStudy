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
    
% %     [Aplan,gains,c]=all2all(Val,N);
% %     simpleVal(t)=mean(gains);
% %     Amaxval(t)=sum(sum(Val.*codeVal2codeBool(Aplan,N)));
% %���ӹ滮��һ�棬�̶�̮������
%     [Qplan1,EQplan1]=minAssign1(max(max(Val))-Val);
%     Qplan_store1(t,:)=Qplan1;
%     EQplan_store1(:,:,t)=EQplan1;
%     Qmaxval1(t)=sum(sum(Val.*codeVal2codeBool(Qplan1,N)));
%     EQmaxval1(t)=sum(sum(Val.*EQplan1));
%���ӹ滮�ڶ��棬���̶�̮������    
    [Qplan2,~]=minAssign(max(max(Val))-Val);
    Qmaxval2(t)=sum(sum(Val.*codeVal2codeBool(Qplan2,N)));
  
    
%     plan=minzp(max(max(Val))-Val);
%     Bplan=codeBool2codeVal(plan,N);
%     Bplan_store(t,:)=Bplan;
%     Bmaxval(t)=sum(sum(Val.*plan));
%     
%     plan=minLzp(max(max(Val))-Val);
%     Lplan=codeBool2codeVal(plan,N);
%     [m,n]=size(Lplan);
%     Lplan_store(t,1:n)=Lplan;
%     Lmaxval(t)=sum(sum(Val.*plan));
    
    
    
    
end