%*******�㷨ִ��ʱ��
clear
clc
n=500;
%���ӹ滮��һ�棬�̶�̮������
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign1(a);
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time01(i)=mean(time3);%�������ӹ滮
end

%ģ��̮��
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign(a);%Ĭ�ϲ�������n
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time02(i)=mean(time3);%
end

%�������ӹ滮
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign1(a+0.000001*rand(i,i));
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time03(i)=mean(time3);%
end

%4
for i=1:n
    for j=1:2
      time1=clock;
       a=rand(i,i);
       a=round(100*a)/100;
       [Qplan1,EQplan1]=minAssign(a+0.000001*rand(i,i));
       time2=clock;
       time3(j)=60*time2(5)-60*time1(5)+time2(6)-time1(6);
    end 
    time04(i)=mean(time3);%
end

save ʱ�������������.mat time01 time02 time03 time04
figure(1)
set(gcf,'color','w');
plot(time01,'r');
hold on
plot(time02,'b');
hold on
plot(time03,'g');
hold on
plot(time04,'y');
xlabel('�����ģ/N');
ylabel('ִ��ʱ��/s');
legend('�������ӹ滮','ģ��̮�����ӹ滮','��Ϊ�������ӹ滮','��Ϊ����ģ��̮�����ӹ滮');


    
   