%�ú������������㷨�����ܣ�������ɷ��󣬼���ÿ���㷨��ʱ�������ֵ
%ֻ����ָ������ save time.mat y1 y2
%function main
%clear;clc;
% ��¼��־
fid = fopen('log.txt','a');
t=datetime;
fprintf(fid,datestr(t));
fprintf(fid,'\n');
fclose(fid); 

N=500; %����ά��1-1000
steps=10; %ÿ���㷨�ظ����ô���

time_auction=zeros(1,N);
val_auction=zeros(1,N);
flag=zeros(1,N);  % �����㷨��������
%plan_auction=zeros(N,N);
time_munkres=zeros(1,N);
val_munkres=zeros(1,N);
%plan_munkres=zeros(N,N);
time_q=zeros(1,N);
val_q=zeros(1,N);
%plan_q=zeros(N,N);
time_base=zeros(1,N);
val_base=zeros(1,N);
%plan_base=zeros(N,N);

for step=1:steps   
  for i =1:N
    fprintf('��%d�ֵ�%dά����\n',step,i);
    w=10*rand(i,i);  
    %% ����
     t1=clock;  
     [plan,~,~,flag(i)] = auction( w,10000*i,0.1/(i+1),0) ;  % �������0.01/i
     t2=clock;
     sum=0;
     for k =1:i
         if plan(k)>0
             sum=sum+w(plan(k),k);
         else
             fid = fopen('log.txt','a');
             fprintf(fid,'����δ���,�����ģΪ%d\n',i);
             fclose(fid); 
             break
         end
     end  
    time_auction(i)=time_auction(i)*(step-1)/step+etime(t2,t1)/step;  % ��λ��,��steps��ƽ��ʱ��
    val_auction(i)=sum;  %ȡ������εĽ��
    %plan_auction(i,1:i)=plan;
    %% ������
    t1=clock;
    plan = munkres(10-w);
    t2=clock;
     sum=0;
     for k =1:i
         sum=sum+w(k,plan(k)); % ע�ⷴ����
     end  
    time_munkres(i)=time_munkres(i)*(step-1)/step+etime(t2,t1)/step;  % ��λ��,��steps��ƽ��ʱ��
    val_munkres(i)=sum;  %ȡ������εĽ��
    %plan_munkres(i,1:i)=plan;
    %% ���ӹ滮
    t1=clock;
    plan = q_min_assign(10- w+0.000001*rand(i,i));
    t2=clock;
    sum=0;
     for k =1:i
         sum=sum+w(plan(k),k);
     end  
    time_q(i)=time_q(i)*(step-1)/step+etime(t2,t1)/step;  % ��λ��,��steps��ƽ��ʱ��
    val_q(i)=sum;  %ȡ������εĽ��
    %plan_q(i,1:i)=plan;
    %% ��׼ֵ
    t1=clock;
    plan = base_min_assign(10- w+0.000001*rand(i,i));
    t2=clock;
    sum=0;
     for k =1:i
         sum=sum+w(plan(k),k);
     end  
    time_base(i)=time_q(i)*(step-1)/step+etime(t2,t1)/step;  % ��λ��,��steps��ƽ��ʱ��
    val_base(i)=sum;  %ȡ���Ľ��
    %plan_base(i,1:i)=plan;  
  end  
end




%�������ݣ�����ʹ��
% save time_and_val.mat ...
%     time_auction val_auction time_munkres val_munkres time_q val_q time_base val_base flag
% plot
figure(1)
plot(time_base,'r');
hold on 
plot(time_auction,'g');
hold on
plot(time_munkres,'b')
hold on
plot(time_q,'m')
title('�㷨ִ��ʱ��')
legend('base','auction','munkres','Q')

figure(2)
plot(val_base,'r');
hold on 
plot(val_auction,'g');
hold on
plot(val_munkres,'b')
hold on
plot(val_q,'m')
title('����ֵ')
legend('base','auction','munkres','Q')

figure(3)
plot(1+(val_auction-val_base)./val_base,'r')
hold on
plot(1+(val_munkres-val_base)./val_base,'g')
hold on
plot(1+(val_q-val_base)./val_base,'b')
hold on
title('�������')
legend('auction','munkres','Q')

figure(4)
plot(flag)
title('�����㷨����������')