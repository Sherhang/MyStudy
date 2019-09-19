clc;clear;
N=10;
flag1=0;

Fx=500000*rand(1,N)';Mx=Fx;
Fy=500000*rand(1,N)';My=Fy;
Tx=500000*rand(1,N)';
Ty=500000*rand(1,N)';

pro=f_probility(Fx,Fy,Tx,Ty,N);
thr=f_threat(Fx,Fy,Tx,Ty,N);
thr1=max(thr);
thr=repmat(thr1,N,1);
Val=pro.*thr;

[ Aplan,Agains,c] =all2all( Val,N );
Amaxval=sum(sum(Val.*codeVal2codeBool(Aplan,N)))


for i=1:N^1.6
    splan(i,:)=randperm(N);
    t=1;
   while 1
            choosePlan=search( Val,splan(i,:),N );
           
            if splan(i,:)==choosePlan 
                flag1=flag1+1;
                break
            end
            [~,p,~]=intersect(c,choosePlan,'rows');
            pp(i,t)=p;
            t=t+1;
            splan(i,:)=choosePlan;
      
   end  
end

[m,n]=size(pp);
for i=1:m
    for j=1:n
    
        if pp(i,j)==0
           pp(i,j)=pp(i,j-1);
        end
    end
end
   
figure(1)
scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz);
plot(Agains,'bo');
hold on

for j=1:n
    for i=1:m
    
        if pp(i,j)~=0
            plot(Agains,'bo');
            hold on
            plot(pp(i,j),Agains(pp(i,j)),'r^','markersize',12);
            hold on
        end
    
    end
    pause(0.3)
    hold off
    plot(Agains,'bo');
    hold on
    for i=1:m
    
        if pp(i,j)~=0
            plot(Agains,'bo');     
            hold on
            plot(pp(i,j),Agains(pp(i,j)),'r^','markersize',12);
            hold on
        end
    gains(i)=sum(sum(Val.*codeVal2codeBool(splan(i,:),N)));
    end
    
    
end

    
    ssplan=find(gains==max(gains));
    Splan=splan(ssplan(1),:);
    Smaxval=sum(sum(Val.*codeVal2codeBool(Splan,N)));
    
    for i=1:N^1.6
        for j=1:N
            sval_store(i,j)=Agains(pp(i,j));
        end 
    end
    sval=max(sval_store);
    sval_mean=mean(sval_store);
    
figure(2)
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
plot(Fx,Fy,'b^','markersize',12);
hold on
plot(Tx,Ty,'ro','markersize',12);
     text(Tx(1),Ty(1),'Ŀ��1');
     text(Tx(2),Ty(2),'Ŀ��2');
     text(Tx(3),Ty(3),'Ŀ��3');
     text(Tx(4),Ty(4),'Ŀ��4');
     text(Tx(5),Ty(5),'Ŀ��5');
     text(Tx(6),Ty(6),'Ŀ��6');
     text(Tx(7),Ty(7),'Ŀ��7');
     text(Tx(8),Ty(8),'Ŀ��8');
     text(Mx(1),My(1),'����1');
     text(Mx(2),My(2),'����2');
     text(Mx(3),My(3),'����3');
     text(Mx(4),My(4),'����4');
     text(Mx(5),My(5),'����5');
     text(Mx(6),My(6),'����6');
     text(Mx(7),My(7),'����7');
     text(Mx(8),My(8),'����8');
for i=1:N
    h=line([Tx(i),Mx(Splan(i))],[Ty(i),My(Splan(i))]);
    hold on
    set(h,'color','g');
end

figure(3)
plot(sval,'r');
hold on 
plot(sval_mean,'b');
xlabel('��������');
ylabel('��������');
legend('��Ⱥ����ֵ','��Ⱥ��ֵ')

    
