clc;clear;
N=9;
scope=500000;
%************* 威胁矩阵与毁伤概率
    Fx=scope*rand(1,N)';
    Fy=scope*rand(1,N)';
   
    Tx=+scope*rand(1,N)';
    Ty=scope*rand(1,N)';
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
    
    
    
    
    
    %Val=rand(N,N);%s随机测试
    Val=round(10000*Val)/10000;%保留小数5位
    %Val(find(Val>0.7))=0.8;  %人为构造固定坍缩方案会出错的问题
    %Val(find(Val<0.1))=0.1;
    V01=Val/max(max(Val));%输入标准化0-1范围
    V01=round(100000*V01)/100000;
    
    
    
    
    
    Val =[0 2.8946 6.5107 5.5845 5.2429 5.8733 4.4377 2.7627 6.5644;
 2.8946 0 4.3313 5.1381 5.7211 3.1830 2.3729 5.2763 5.0574;
 6.5107 4.3313 0 3.6548 5.2943 1.8590 2.0889 9.2412 8.3103;
 5.5845 5.1381 3.6548 0 1.7362 4.8792 3.3486 8.19021 0.1465;
 5.2429 5.7211 5.2943 1.7362 0 6.2723 4.5224 7.53171 0.7633;
 5.8733 3.1830 1.8590 4.8792 6.2723 0 1.8705 8.4338 6.4969;
 4.4377 2.3729 2.0889 3.3486 5.5224 1.8705 0 7.1555 6.9906;
 2.7627 5.2763 9.2412 8.1902 7.5317 8.4338 7.1555 0 7.1508;
6.5644 5.0574 8.31031 0.14651 0.7633 6.4969 6.9906 7.1508 0];
V01=max(max(Val))-Val;%求最小值
% 计算距离矩阵
for i=1:N
    for j=1:N
       D(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
d01=D/max(max(D));

[Qplan_unique,EQplan,Qminval,cou] = minAssign(V01,500);%测量次数
%[Qplan_unique,EQplan,Qminval,cou] = minAssign(1-V01+0.000000001*rand(N,N),50);
Qmaxval=sum(sum(Val.*codeVal2codeBool(Qplan_unique(1,:),N)));

[Bplan,Bminval]=minBzp(V01);
Bmaxval=sum(sum(Val.*codeVal2codeBool(Bplan,N)));

[Bminval,Qminval,Qminval-Bminval]
[Bmaxval,Qmaxval,Qmaxval-Bmaxval]



figure(1)%方案图
set(gcf,'color','w');
Qplan=Qplan_unique(1,:);
plot(Fx(1),Fy(1),'b^','markersize',12);
hold on
plot(Tx(1),Ty(1),'ro','markersize',12);
legend('导弹','目标');
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




figure(2);%系数矩阵密度图
set(gcf,'color','w');
%figure('color',[1 1 1]);
V02=(Val-min(min(Val)))/(max(max(Val))-min(min(Val)));
for i=1:N
    for j=1:N
        x=i+0.3*(randn(1,round(V02(i,j)*300)));%产生白噪声
        y=j+0.3*(randn(1,round(V02(i,j)*300)));
        plot(x,y,'b.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
grid on

figure(3);%量子云图
set(gcf,'color','w');
%figure('color',[1 1 1]);

for i=1:N
    for j=1:N
        x=i+0.4*(randn(1,round(EQplan(i,j)*1000)));%产生白噪声
        y=j+0.4*(randn(1,round(EQplan(i,j)*1000)));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
grid on