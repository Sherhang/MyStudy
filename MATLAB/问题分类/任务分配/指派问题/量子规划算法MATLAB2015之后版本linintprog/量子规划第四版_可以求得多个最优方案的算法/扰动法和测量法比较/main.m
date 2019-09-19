clc;clear;
N=10;
%************* 威胁矩阵与毁伤概率
    Fx=200000*rand(1,N)';
    Fy=200000*rand(1,N)';
   
    Tx=200000*rand(1,N)';
    Ty=200000*rand(1,N)';
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
    Val=rand(N,N);%s随机测试
    Val=round(10*Val)/10;%保留小数5位
    V01=Val/max(max(Val));%输入标准化0-1范围
%   Val(find(Val>0.975))=0.975;  %人为构造固定坍缩方案会出错的问题
%   Val(find(Val<0.1))=0.1;
% 计算距离矩阵
for i=1:N
    for j=1:N
       D(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
d01=D/max(max(D));


[Qplan_unique_noise,~,Qminval_noise0,Qbad_noise] = minAssign_mplan(1-V01,10);%扰动法
Qminval_noise=sum(sum(Val.*codeVal2codeBool(Qplan_unique_noise(1,:),N)));
[plan_unique,EQplan,minval0,cou] = minAssign( 1-V01,1);%量子模拟，测量法
minval=sum(sum(Val.*codeVal2codeBool(plan_unique(1,:),N)));
    
for i=1:10
    [Bplan,Bminval0]=minBzp(1-V01);
    Bplan_store(i,:)=Bplan;
    Bplan_unique=unique(Bplan_store,'rows');
end
Bminval=sum(sum(Val.*codeVal2codeBool(Bplan_unique(1,:),N)));

fprintf('三种算法最优值为：%f %f %f\n',Qminval_noise,minval,Bminval);

[num1,~]=size(Qplan_unique_noise);
fprintf('10次噪声干扰法找出方案数为%d\n',num1);
[num2,~]=size(plan_unique);
fprintf('1次量子测量法找出方案数为%d\n',num2);
[num3,~]=size(Bplan_unique);
fprintf('10次分支定界法找出方案数为%d\n',num3);

figure(3);%量子云图

title('量子云图');
set(gcf,'color','w');
%figure('color',[1 1 1]);
for i=1:N
    for j=1:N
        x=i+0.4*(randn(1,round(EQplan(i,j)*800)));%产生白噪声
        y=j+0.4*(randn(1,round(EQplan(i,j)*800)));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
grid on

