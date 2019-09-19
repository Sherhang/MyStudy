clear;
clc;
gen=500;
t1=clock;
global popsize; %��Ⱥ��ģ
global pop; %��Ⱥ
global c1; %�������ŵ���ϵ��
global c2; %ȫ�����ŵ���ϵ��\
global gbest;
% global gbest_x; %ȫ�����Ž� x ������
% global gbest_y; %ȫ�����Ž� y ������
% global gbest_z; %ȫ�����Ž� z ������
% global gbest_w; %ȫ�����Ž� w ������
global best_fitness; %���Ž�
global exetime; %��ǰ��������
global max_velocity; %����ٶ�
global totaltime;
initial; %�����ʼ��
for exetime=1:gen
    adapting; %������Ӧֵ
    updatepop; %��������λ��
    f(1,exetime)=best_fitness;
    f(2,exetime)=mean(pop(:,46));
end
t2=clock;
i=1:gen;  
plot(i,f(1,i),'r');
hold on
plot(i,f(2,i),'b');
xlabel('steps');
ylabel('����ֵ');
legend('����ֵ','��Ⱥ��ֵ')
solution=gbest
best_fitness
totaltime=t2-t1

