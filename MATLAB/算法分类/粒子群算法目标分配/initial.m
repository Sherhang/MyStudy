%gen=1;
popsize=100;
max_velocity=8;
best_fitness=0;
% gbest_x=[0 ;0 ;0];
% gbest_y=[0; 0 ;0];
% gbest_z=[0 ;0; 0];
% gbest_w=[0 ;0; 0];
%totaltime=0;
%ʵ������
%[1 2 2 1]��ʾ��һ��������Ԫ���ص�һ�͵��ĸ�Ŀ�꣬�ڶ�
%��������Ԫ���صڶ��͵�����Ŀ��
pop(popsize,47)=0;
%��ʼ����Ⱥ������ popsize �� 14 �е� 0 ����
% for i=1:popsize
%pop(1,1:15)=[4     7     2     7     5     5     8     1     1     2     5     3     7     4     3];
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
%pop(1,1:15)=[4     7    1     7     5     3     8     2     1     7     5     3     7     4     3];

% % pop(i,1)=randpop(2); %��ʼ����Ⱥ�е�һ������λ��
% % pop(i,2)=randpop(2);
% % pop(i,3)=randpop(2);
% % pop(i,4)=randpop(2);
% pop(i,5)=pop(i,1);
% %��ʼ״̬�� ����������ֵ���ڳ�ʼλ��
% pop(i,6)=pop(i,2);
% pop(i,7)=pop(i,3);
% pop(i,8)=pop(i,4);
% pop(i,9)=round(rand()); %��ʼ�������ٶ� ��ֵΪ 1
% pop(i,10)=round(rand());
% pop(i,11)=round(rand());
% pop(i,12)=round(rand());
% pop(i,13)=0;
% pop(i,14)=0;
% end
c1=3;
c2=2;
% gbest_x(1)=pop(1,1);%ȫ�����ų�ʼֵΪ��Ⱥ��һ�����ӵ�λ��
% gbest_y(1)=pop(1,2);
% gbest_z(1)=pop(1,3);
% gbest_w(1)=pop(1,4);
