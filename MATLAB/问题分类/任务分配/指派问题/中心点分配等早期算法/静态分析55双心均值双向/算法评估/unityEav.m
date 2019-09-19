%***********综合评估***%
%******算法性能评估，随机生成位置，评估算法结果与完全法是否一致***%
clc;clear;
steps=100;
N=7;

flag11=0;
flag12=0;
flag21=0;
flag22=0;
flag31=0;
flag32=0;
    fy(:,1)=-500*[1 3 5 7 9 11 13]';
    fx(:,1)=300.*[1 2 3 4 5 6 7 ]';
    mx(:,1)=fx(:,1);my(:,1)=fy(:,1);
   tx(:,1)=100000+500*[4 5 7 9 10 16 18  ]';
   ty(:,1)=100+500*[3 5 6 3 4 8  9 ]';
for t=1:steps
   fx(:,t+1)=fx(:,t)+90*[1 2 3 5 4 6 8 ]'+2*rand(N,1);
   fy(:,t+1)=fy(:,t)-26*[2 2 2 2 2 2 2]';
   mx(:,t)=fx(:,t);my(:,t)=fy(:,t);
   tx(:,t+1)=tx(:,t)+80*[4 5 6 5 6 4 6]'+5*rand(N,1);
   ty(:,t+1)=ty(:,t)+80*[6 5 4 0 1 2 3]';
end
for t=1:steps
    %% 双心点
    doublePoint;
    Dmaxval(t)=Dmax;
    all2all;
    Amaxval(t)=gains(solution);%完全法
    Aminval(t)=min(gains);
    if abs((Amaxval(t)-Dmaxval(t))./Amaxval(t))<=0.05
        flag11=flag11+1;
    end
     
    if Aplan==Dplan
        flag12=flag12+1;
    end
    %% 中心点
    singlePoint;
    Smaxval(t)=Smax;
    all2all;
    if abs((Amaxval(t)-Smaxval(t))./Amaxval(t))<=0.05
        flag21=flag21+1;
    end
     
    if Aplan==Splan
        flag22=flag22+1;
    end
    %% 均值算法
    meanrows;
    Mmaxval(t)=Mmax;
    all2all;
    if abs((Amaxval(t)-Mmaxval(t))./Amaxval(t))<=0.01
        flag31=flag31+1;
    end
     
    if Aplan==Mplan
        flag32=flag32+1;
    end
   %% 三种算法取最佳算法
   zonghe=[Smaxval(t),Dmaxval(t),Mmaxval(t)];
   maxval(t)=max(zonghe);
  [temp,I]=max(zonghe);
   flag=num2str(I);
   switch I
       case 1
           Zplan=Splan;
       case 2
           Zplan=Dplan;
       case 3
           Zplan=Mplan;
   end
   %% 为了比较一般方案，取方案均值
   simpleval(t)=mean(gains);
   %% 对当前最优方案进行邻近点搜索
%    temp1=nchoosek(1:N,3);
%    SearchPlan(:,:)=Dplan;
%    for i=1: nchoosek(N,3)
%        SearchPlan([temp1(i,1) temp1(i,2) temp1(i,3)],2)=Dplan([temp1(i,2) temp1(i,3) temp1(i,1)],2);
%        plan(:,:,i)=zeros(N);
%        for j=1:N
%           plan(SearchPlan(j,2),j,i)=1;
%        end
%        temp=threat.*pro.*plan(:,:,i);
%        SearchMaxval(t)=Dmaxval(t);
%        if temp>maxval(t)
%            SearchMaxval(t)=temp;
%        end
%    end
[~,b2,~]=intersect(c,Dplan(:,2)','rows')  ; 
plan1(:,:,1)=zeros(N);
  for i=1:300
    row(i)=b2+i;
    if(row(i)>factorial(N))
        row(i)=row(i)-factorial(N);
    end
    
      for j=1:N
            plan1(j,c(row(i),j),i)=1;
      end
    temp =sum(sum(pro.*threat.*plan(:,:,i)));
    SearchMaxval(t)=Dmaxval(t);
      if temp>Dmaxval(t)
          SearchMaxval(t)=temp;
      end
  end
end
result11=flag11/steps
result12=flag12/steps
result21=flag21/steps
result22=flag22/steps
result31=flag31/steps
result32=flag32/steps
figure(1)
plot(Amaxval,'r')
hold on
plot(Dmaxval,'b')
hold on
plot(Smaxval,'g')
hold on
plot(Mmaxval,'k')
hold on
plot(maxval,'y*')
hold on
plot(simpleval,'mo')
hold on
plot(SearchMaxval,'r*')

%% 
figure(2);
plot((Amaxval-Dmaxval)./(Amaxval-Aminval),'b')
hold on
plot((Amaxval-Smaxval)./(Amaxval-Aminval),'g')  
hold on
plot((Amaxval-Mmaxval)./(Amaxval-Aminval),'k')  
hold on
plot((Amaxval-maxval)./(Amaxval-Aminval),'y*')  
hold on 
plot((Amaxval-simpleval)./(Amaxval-Aminval),'mo')
hold on 
plot((Amaxval-SearchMaxval)./(Amaxval-Aminval),'r*')
%% 
figure(3)
plot(gains,'o');
hold on
hh1=line([0,5040],[maxval(steps),maxval(steps)]);
set(hh1,'color','r');
hold off
hh2=line([0,5040],[SearchMaxval(steps),SearchMaxval(steps)]);
set(hh2,'color','g');
%%
figure(4)
for i=1:steps
     plot(tx(:,i),ty(:,i),'r*');
     hold on;
     plot(fx(:,i),fy(:,i),'bo');
%      axis(100*[-100 1500 -200 2000]);
     hold on;   
end
     text(tx(1,1)-100,ty(1,1)+20,'目标1');
     text(tx(2,1)-100,ty(2,1)+20,'目标2');
     text(tx(3,1)-100,ty(3,1)+20,'目标3');
     text(tx(4,1)-100,ty(4,1)+20,'目标4');
     text(tx(5,1)-100,ty(5,1)+20,'目标5');
     text(tx(6,1)-100,ty(6,1)+20,'目标6');
     text(tx(7,1)-100,ty(7,1)+20,'目标7');
    
     text(mx(1,1)-50,my(1,1),'导弹1');
     text(mx(2,1)-50,my(2,1),'导弹2');
     text(mx(3,1)-50,my(3,1),'导弹3');
     text(mx(4,1)-50,my(4,1),'导弹4');
     text(mx(5,1)-50,my(5,1),'导弹5');
     text(mx(6,1)-50,my(6,1),'导弹6');
     text(mx(7,1)-50,my(7,1),'导弹7');
     
%      k=90;
%      text(Tpx(1,k)-10,Tpy(1,k)-10,'目标1');
%      
%      text(Tpx(2,k),Tpy(2,k),'目标2');
%      text(Tpx(3,k),Tpy(3,k),'目标3');
%      text(Tpx(4,k),Tpy(4,k),'目标4');
%      text(Tpx(5,k),Tpy(5,k),'目标5');
%      text(Tpx(6,k),Tpy(6,k),'目标6');
%      text(Tpx(7,k),Tpy(7,k),'目标7');
%      text(Tpx(8,k),Tpy(8,k),'目标8');
%      text(Mpx(1,k),Mpy(1,k),'导弹1');
%      text(Mpx(2,k),Mpy(2,k),'导弹2');
%      text(Mpx(3,k),Mpy(3,k),'导弹3');
%      text(Mpx(4,k),Mpy(4,k),'导弹4');
%      text(Mpx(5,k),Mpy(5,k),'导弹5');
%      text(Mpx(6,k),Mpy(6,k),'导弹6');
%      text(Mpx(7,k),Mpy(7,k),'导弹7');
%      text(Mpx(8,k),Mpy(8,k),'导弹8');
     xlabel('m');
     ylabel('m');

