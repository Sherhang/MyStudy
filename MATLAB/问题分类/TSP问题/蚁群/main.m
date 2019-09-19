%��Ⱥ�㷨���TSP�����matlab����
clear all
close all
clc
%��ʼ����Ⱥ
m=30;%��Ⱥ�����ϵ���������m�ӽ�����ڳ��и���nʱ�����㷨���������ٵĵ����������ҵ����Ž�
C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];%���е��������1.5378E4ģ���˻��㷨��
Nc_max=200;%���ѭ�����������㷨�����Ĵ������༴���ϳ����Ĳ�����ÿ�����ϵ�������Ȼ����m��
alpha=0.1;%�������˶���������������Ϣ������Ϣ�أ�������ѡ��·��ʱ�������Ҫ�̶ȣ�alpha����ʱ���㷨������һ�������󽫳���ͣ������
beta=10;%����ʽ����������ѡ��·��ʱ�������Ҫ�̶�
rho=0.5;%0<rho<1,��ʾ·������Ϣ�ص�˥��ϵ������ƻӷ�ϵ��������ϵ������1-rho��ʾ��Ϣ�صĳ־���ϵ��
Q=100;%�����ͷŵ���Ϣ�������Ա��㷨������Ӱ�첻��


%������ʼ��
n=size(C,1);%��ʾTSP����Ĺ�ģ���༴���е�����
D=ones(n,n);%��ʾ������ȫ��ͼ�ĸ�Ȩ�ڽӾ��󣬼�¼����֮��ľ���
for i=1:n
   for j=1:n
           if i<j
               D(i,j)=sqrt((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2);
           end
       D(j,i)=D(i,j);
   end
end
eta=1./D;%����ʽ���ӣ�������Ϊ����֮�����ĵ���
pheromone=ones(n,n);%��Ϣ�ؾ���,��������κ���������֮��·���ϵĳ�ʼ��Ϣ�ض�Ϊ1
tabu_list=zeros(m,n);%���ɱ���¼�����Ѿ��߹��ĳ��У������ڱ���ѭ���в����پ�����Щ���С�������ѭ�������󣬽��ɱ������������ϵ�ǰ�������Ľ����������������·����·���ĳ���
Nc=0;%ѭ������������
routh_best=zeros(Nc_max,n);%����ѭ�������·��
length_best=ones(Nc_max,1);%����ѭ�����·���ĳ���
length_average=ones(Nc_max,1);%����ѭ������·����ƽ������


while Nc<Nc_max
    %��mֻ���Ϸ���n��������
      rand_position=[];
      for i=1:ceil(m/n)
            rand_position=[rand_position,randperm(n)];
      end
      tabu_list(:,1)=(rand_position(1:m))';%�����Ϸ��ڳ�����֮��Ľ��ɱ���i�б�ʾ��iֻ���ϣ���i�е�һ��Ԫ�ر�ʾ��iֻ�������ڵĳ�ʼ����
     %mֻ���ϰ����ʺ���ѡ����һ�����У��ڱ���ѭ������ɸ��Ե�����
      for j=2:n
        for i=1:m
            city_visited=tabu_list(i,1:(j-1));%�ѷ��ʵĳ���
            city_remained=zeros(1,(n-j+1));%�����ʵĳ���
             probability=city_remained;%�����ʳ��еķ��ʸ���
            cr=1;
            for k=1:n%forѭ������������ʵĳ��С�����������и�����5�����ѷ��ʵĳ���city_visited=[2 4],�򾭹���forѭ����city_remanied=[1 3 5]
                   if length(find(city_visited==k))==0
                          city_remained(cr)=k;
                          cr=cr+1;
                   end
            end


        %״̬ת�ƹ���****************************************
               q0=0.5;
              if rand>q0
                       for k=1:length(city_remained)
                             probability(k)=(pheromone(city_visited(end),city_remained(k)))^alpha*(eta(city_visited(end),city_remained(k)))^beta;
                             position=find(probability==max(probability));
                             to_visit=city_remained(position(1));
                       end
              else
                       for k=1:length(city_remained)
                               probability(k)=(pheromone(city_visited(end),city_remained(k)))^alpha*(eta(city_visited(end),city_remained(k)))^beta;
                       end
                       probability=probability/sum(probability);
                       pcum=cumsum(probability);
                       select=find(pcum>=rand);
                       to_visit=city_remained(select(1));
              end
              tabu_list(i,j)=to_visit;
 %**************************************************************

        end
      end
     if Nc>0
            tabu_list(1,:)=routh_best(Nc,:);%����һ��������·�������Ž⣩������������֤��һ���е�����Ӧ�������Ϣ���ᶪʧ
     end
  %��¼����ѭ�������·��
total_length=zeros(m,1);%mֻ�����ڱ���ѭ���зֱ����߹���·������
  for i=1:m
         r=tabu_list(i,:);%ȡ����iֻ�����ڱ���ѭ�������ߵ�·��
          for j=1:(n-1)
             total_length(i)=total_length(i)+D(r(j),r(j+1));%��iֻ���ϱ���ѭ���д������е��յ�������߹���·������
          end
          total_length(i)=total_length(i)+D(r(1),r(n));%���յõ���iֻ�����ڱ���ѭ�������߹���·������
  end
 length_best(Nc+1)=min(total_length);%��mֻ�����ڱ���ѭ��������·�����ȵ���Сֵ��Ϊ����ѭ�������·���ĳ���
position=find(total_length==length_best(Nc+1));%�ҵ����·����λ�ã������·���ǵڼ�ֻ���ϻ��ļ�ֻ�����߳�����
 routh_best(Nc+1,:)=tabu_list(position(1),:);%�ѵ�һ���߳����·���������ڱ���ѭ�������ߵ�·����Ϊ����ѭ���е�����·��
 length_average(Nc+1)=mean(total_length);%���㱾��ѭ����mֻ��������·����ƽ������
Nc=Nc+1;
 %������Ϣ��
 delta_pheromone=zeros(n,n);
 for i=1:m
      for j=1:(n-1)
             delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))=delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))+Q/total_length(i);%total_length(i)Ϊ��iֻ�����ڱ���ѭ�������߹���·�����ȣ�����ϵͳ����������ϵͳ������ϵͳ�ĵط���
      end
      delta_pheromone(tabu_list(i,n),tabu_list(i,1))=delta_pheromone(tabu_list(i,n),tabu_list(i,1))+Q/total_length(i);%���˰ѵ�iֻ�����ڱ���ѭ����������·�����ͷŵ���Ϣ���Ѿ��ۼ���ȥ
 end%���˰�mֻ�����ڱ���ѭ����������·�����ͷŵ���Ϣ���Ѿ��ۼ���ȥ
  pheromone=(1-rho).*pheromone+delta_pheromone;%����ѭ��������·���ϵ���Ϣ��
  %���ɱ����㣬׼����һ��ѭ������������һ��ѭ�����ֿ������ɵؽ���ѡ��
  tabu_list=zeros(m,n);
end


%������������ͼ��
position=find(length_best==min(length_best));
shortest_path=routh_best(position(1),:)
shortest_length=length_best(position(1))
%�������·��
figure(1)

N=length(shortest_path);
scatter(C(:,1),C(:,2),50,'filled');
hold on
plot([C(shortest_path(1),1),C(shortest_path(N),1)],[C(shortest_path(1),2),C(shortest_path(N),2)])

hold on
for i=2:N
    plot([C(shortest_path(i-1),1),C(shortest_path(i),1)],[C(shortest_path(i-1),2),C(shortest_path(i),2)])
    hold on
end
%����ÿ��ѭ�����·�����Ⱥ�ƽ��·������
figure(2)

plot(length_best,'r')

hold on
