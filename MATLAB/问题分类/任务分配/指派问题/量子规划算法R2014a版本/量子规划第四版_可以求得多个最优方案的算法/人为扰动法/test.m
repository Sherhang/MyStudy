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
    Val=round(1000*Val)/1000;%保留小数位
%   Val(find(Val>0.975))=0.975;  %人为构造固定坍缩方案会出错的问题
%   Val(find(Val<0.1))=0.1;
 
    
 %量子规划，固定坍缩方案，加人为扰动
for i=1:100  %测量次数 
   [Qplan1,EQplan1]=minAssign(max(max(Val))-Val+0.00001*rand(N,N));
    Qplan_store1(i,:)=Qplan1;
    EQplan_store1(:,:,i)=EQplan1;
    Qmaxval1(i)=sum(sum(Val.*codeVal2codeBool(Qplan1,N)));
    EQmaxval1(i)=sum(sum(Val.*EQplan1));
end
[Qplan_unique1,row,clo]=unique(Qplan_store1,'rows');


figure(1)
plot(Qmaxval1)
