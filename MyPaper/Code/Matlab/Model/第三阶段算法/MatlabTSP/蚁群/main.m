%蚁群算法求解TSP问题的matlab程序
clear all
close all
clc
%初始化蚁群
m=30;%蚁群中蚂蚁的数量，当m接近或等于城市个数n时，本算法可以在最少的迭代次数内找到最优解
C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];%城市的坐标矩阵1.5378E4模拟退火算法解

city144=[3639	1315;
    4177	2244;
    3569	1438;
    3757	1187;
    3904	1289;
    3488	1535;
    3506	1221;
    3374	1750;
    3237	1764;
    3326	1556;
    3089	1251;
    3258	911;
    3238	1229;
    3646	234;
    4172	1125;
    4089	1387;
    4020	1142;
    4196	1044;
    4095	626;
    4312	790;
    4403	1022;
    4685	830;
    4361	73;
    4720	557;
    4634	654;
    4153	426;
    2846	1951;
    2831	2099;
    3054	1710;
    3086	1516;
    2562	1756;
    2716	1924;
    2291	1403;
    2751	1559;
    2012	1552;
    1779	1626;
    682	825;
    1478	267;
    518	1251;
    278	890;
    1332	695;
    3715	1678;
    4016	1715;
    4181	1574;
    4087	1546;
    3929	1892;
    4062	2220;
    3751	1945;
    4061	2370;
    4207	2533;
    4201	2397;
    4139	2615;
    3777	2095;
    3780	2212;
    3888	2261;
    3594	2900;
    3678	2463;
    3676	2578;
    3789	2620;
    4029	2838;
    3862	2839;
    3928	3029;
    4263	2931;
    4186	3037;
    3492	1901;
    3322	1916;
    3479	2198;
    3429	1908;
    3318	2408;
    3176	2150;
    3296	2217;
    3229	2367;
    3394	2643;
    3402	2912;
    3101	2721;
    3402	2510;
    3792	3156;
    3468	3018;
    3142	3421;
    3356	3212;
    3130	2973;
    3044	3081;
    2765	3321;
    3140	3557;
    2545	2357;
    2769	2492;
    2611	2275;
    2348	2652;
    3712	1399;
    3493	1696;
    3791	1339;
    3376	1306;
    3188	1881;
    3814	261;
    3583	864;
    4297	1218;
    4116	1187;
    4252	882;
    4386	570;
    4643	404;
    4784	279;
    3077	1970;
    1828	1210;
    2061	1277;
    2788	1491;
    2381	1676;
    1777	892;
    1064	284;
    3688	1818;
    3896	1656;
    3918	2179;
    3972	2136;
    4029	2498;
    3766	2364;
    3896	2443;
    3796	2499;
    3478	2705;
    3810	2969;
    4167	3206;
    3486	1755;
    3334	2107;
    3587	2417;
    3507	2376;
    3264	2551;
    3360	2792;
    3439	3201;
    3526	3263;
    3012	3394;
    2935	3240;
    3053	3739;
    2284	2803;
    2577	2574;
    2860	2862;
    2801	2700;
    2370	2975;
    1084	2313;
    2778	2826;
    2126	2896;
    1890	3033;
    3538	3298;
    2592	2820;
    2401	3164;
    1304	2312;
    3470	3304;];%中国144城市相对坐标，最小距离为30347，蚁群优化算法数据为30380
C = city144; % 选择数据集

tic;
Nc_max=100;%最大循环次数，即算法迭代的次数，亦即蚂蚁出动的拨数（每拨蚂蚁的数量当然都是m）
alpha=0.1;%蚂蚁在运动过程中所积累信息（即信息素）在蚂蚁选择路径时的相对重要程度，alpha过大时，算法迭代到一定代数后将出现停滞现象
beta=10;%启发式因子在蚂蚁选择路径时的相对重要程度
rho=0.6;%0<rho<1,表示路径上信息素的衰减系数（亦称挥发系数、蒸发系数），1-rho表示信息素的持久性系数
Q=100;%蚂蚁释放的信息素量，对本算法的性能影响不大


%变量初始化
n=size(C,1);%表示TSP问题的规模，亦即城市的数量
D=ones(n,n);%表示城市完全地图的赋权邻接矩阵，记录城市之间的距离
for i=1:n
   for j=1:n
           if i<j
               D(i,j)=sqrt((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2);
           end
       D(j,i)=D(i,j);
   end
end
eta=1./D;%启发式因子，这里设为城市之间距离的倒数
pheromone=ones(n,n);%信息素矩阵,这里假设任何两个城市之间路径上的初始信息素都为1
tabu_list=zeros(m,n);%禁忌表，记录蚂蚁已经走过的城市，蚂蚁在本次循环中不能再经过这些城市。当本次循环结束后，禁忌表被用来计算蚂蚁当前所建立的解决方案，即经过的路径和路径的长度
Nc=0;%循环次数计数器
routh_best=zeros(Nc_max,n);%各次循环的最短路径
length_best=ones(Nc_max,1);%各次循环最短路径的长度
length_average=ones(Nc_max,1);%各次循环所有路径的平均长度


while Nc<Nc_max
    %将m只蚂蚁放在n个城市上
      rand_position=[];
      for i=1:ceil(m/n)
            rand_position=[rand_position,randperm(n)];
      end
      tabu_list(:,1)=(rand_position(1:m))';%将蚂蚁放在城市上之后的禁忌表，第i行表示第i只蚂蚁，第i行第一列元素表示第i只蚂蚁所在的初始城市
     %m只蚂蚁按概率函数选择下一座城市，在本次循环中完成各自的周游
      for j=2:n
        for i=1:m
            city_visited=tabu_list(i,1:(j-1));%已访问的城市
            city_remained=zeros(1,(n-j+1));%待访问的城市
             probability=city_remained;%待访问城市的访问概率
            cr=1;
            for k=1:n%for循环用于求待访问的城市。比如如果城市个数是5，而已访问的城市city_visited=[2 4],则经过此for循环后city_remanied=[1 3 5]
                   if length(find(city_visited==k))==0
                          city_remained(cr)=k;
                          cr=cr+1;
                   end
            end


        %状态转移规则****************************************
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
            tabu_list(1,:)=routh_best(Nc,:);%将上一代的最优路径（最优解）保留下来，保证上一代中的最适应个体的信息不会丢失
     end
  %记录本次循环的最佳路线
total_length=zeros(m,1);%m只蚂蚁在本次循环中分别所走过的路径长度
  for i=1:m
         r=tabu_list(i,:);%取出第i只蚂蚁在本次循环中所走的路径
          for j=1:(n-1)
             total_length(i)=total_length(i)+D(r(j),r(j+1));%第i只蚂蚁本次循环中从起点城市到终点城市所走过的路径长度
          end
          total_length(i)=total_length(i)+D(r(1),r(n));%最终得到第i只蚂蚁在本次循环中所走过的路径长度
  end
 length_best(Nc+1)=min(total_length);%把m只蚂蚁在本次循环中所走路径长度的最小值作为本次循环中最短路径的长度
position=find(total_length==length_best(Nc+1));%找到最短路径的位置，即最短路径是第几只蚂蚁或哪几只蚂蚁走出来的
 routh_best(Nc+1,:)=tabu_list(position(1),:);%把第一个走出最短路径的蚂蚁在本次循环中所走的路径作为本次循环中的最优路径
 length_average(Nc+1)=mean(total_length);%计算本次循环中m只蚂蚁所走路径的平均长度
Nc=Nc+1;
 %更新信息素
 delta_pheromone=zeros(n,n);
 for i=1:m
      for j=1:(n-1)
             delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))=delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))+Q/total_length(i);%total_length(i)为第i只蚂蚁在本次循环中所走过的路径长度（蚁周系统区别于蚁密系统和蚁量系统的地方）
      end
      delta_pheromone(tabu_list(i,n),tabu_list(i,1))=delta_pheromone(tabu_list(i,n),tabu_list(i,1))+Q/total_length(i);%至此把第i只蚂蚁在本次循环中在所有路径上释放的信息素已经累加上去
 end%至此把m只蚂蚁在本次循环中在所有路径上释放的信息素已经累加上去
  pheromone=(1-rho).*pheromone+delta_pheromone;%本次循环后所有路径上的信息素
  %禁忌表清零，准备下一次循环，蚂蚁在下一次循环中又可以自由地进行选择
  tabu_list=zeros(m,n);
end 

toc
%输出结果，绘制图形
position=find(length_best==min(length_best));
shortest_path=routh_best(position(1),:);
shortest_length=length_best(position(1));
fprintf('%f',shortest_length);
%绘制最短路径
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
%绘制每次循环最短路径长度和平均路径长度
figure(2)

plot(length_best,'r')

hold on
