clear;
clc;
%% ��ʼ��
global popsize; %��Ⱥ��ģ
global pop; %��Ⱥ
global best_fitness; 
global gbest;

gen=1000;%  ��������
popsize=50;% ��Ⱥ������
max_velocity=8;
best_fitness=0;
pop(popsize,47)=0;
c1=2;
c2=3
for i=1:popsize
    for j=1:15
        pop(i,j)=randpop(8);
    end
    
    for j=16:30
        pop(i,j)=pop(i,j-15);
    end
    for j=31:45
        pop(i,j)=round(rand());
    end
    pop(i,46:47)=[0,0];
end
c1=2;
c2=3;
%% ��Ӧֵ����

