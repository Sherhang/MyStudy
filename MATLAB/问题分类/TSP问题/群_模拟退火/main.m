% TSP模拟退火算法
% 加入概率修正系数，明显提高了算法性能，要保证终止温度附近只有差别非常小的解可以保留下来。还有一种思路是计算一下退火温度，需要确定两个参数
% 群，用矩阵实现
 
      clear
      clc
    a = 0.9;       %温度衰减函数的参数,一般文献取0.9以上
    t0 = 100;        %初始温度
    tf = 1;         %终止温度
    t = t0;
    flag=0;
    Markov_length =1000;  %Markov链长度
  
city30=[41 94;37 84;54 67;25 62;7 64;2 99;68 58;71 44;54 62;83 69;64 60;18 54;22 60;
         83 46;91 38;25 38;24 42;58 69;71 71;74 78;87 76;18 40;13 40;82 7;62 32;58 35;45 21;41 26;44 35;4 50];%30 cities d'=423.741 by D B Fogel
city31=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];     
     city50=[31 32;32 39;40 30;37 69;27 68;37 52;38 46;31 62;30 48;21 47;25 55;16 57;
        17 63;42 41;17 33;25 32;5 64;8 52;12 42;7 38;5 25; 10 77;45 35;42 57;32 22;
        27 23;56 37;52 41;49 49;58 48;57 58;39 10;46 10;59 15;51 21;48 28;52 33;
        58 27;61 33;62 63;20 26;5 6;13 13;21 10;30 15;36 16;62 42;63 69;52 64;43 67];%50 cities d'=427.855 by D B Fogel
    city75=[48 21;52 26;55 50;50 50;41 46;51 42;55 45;38 33;33 34;45 35;40 37;50 30;
        55 34;54 38;26 13;15 5;21 48;29 39;33 44;15 19;16 19;12 17;50 40;22 53;21 36;
        20 30;26 29;40 20;36 26;62 48;67 41;62 35;65 27;62 24;55 20;35 51;30 50;
        45 42;21 45;36 6;6 25;11 28;26 59;30 60;22 22;27 24;30 20;35 16;54 10;50 15;
        44 13;35 60;40 60;40 66;31 76;47 66;50 70;57 72;55 65;2 38;7 43;9 56;15 56;
        10 70;17 64;55 57;62 57;70 64;64 4;59 5;50 4;60 15;66 14;66 8;43 26];%75 cities d'=545.6549 by D B Fogel,原数据最小值不准
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
    city=city31;
    amount=size(city,1);
    num=10;%种群数量
for i=1:amount
    for j=1:amount
            D(i,j)=((city(i,1)-city(j,1))^2+(city(i,2)-city(j,2))^2)^0.5;
    end
end   

for i=1:num 
    sol_new(i,:) = randperm(amount);% %产生初始解，sol_new是每次产生的新解
end
 %产生初始解，sol_new是每次产生的新解
sol_current = sol_new;      %sol_current是当前解
sol_best = sol_new;         %sol_best是冷却中的最好解
E_current = 10^10*ones(1,num);            %E_current是当前解对应的回路距离
E_best = E_current;               %E_best
noft=0;

 
while t >= tf
   for r = 1:Markov_length      %Markov链长度
    %产生随机扰动
    if(rand < 0.5)
        %2交换，两个序号之间的数倒序
        ind1 = 0;
        ind2 = 0;
        while(ind1 >= ind2)
           ind1 = ceil(rand * amount);
           ind2 = ceil(rand * amount);
        end
        temp1=sol_new(:,[ind1:ind2]);
        temp1=fliplr(temp1);%倒序
        sol_new(:,[ind1:ind2])=temp1;
    else
    %else if(rand<1)
        %三交换
        ind1 = 0;
        ind2 = 0;
        ind3 = 0;
        while( (ind1 == ind2) || (ind1 == ind3) || (ind2 == ind3) || (abs(ind1 -ind2) == 1) )
            ind1 = ceil(rand * amount);
            ind2 = ceil(rand * amount);
            ind3 = ceil(rand * amount);
        end
        tmp1 = ind1;
        tmp2 = ind2;
        tmp3 = ind3;
        %确保 ind1 < ind2 < ind3
        s=sort([ind1 ind2 ind3]);
        ind1=s(1);ind2=s(2);ind3=s(3);   
        tmplist1 = sol_new(:,(ind1 + 1):(ind2 - 1));
        sol_new(:,(ind1 + 1):(ind1 + (ind3 - ind2 + 1) )) = sol_new(:,(ind2):(ind3));
        sol_new(:,(ind1 + (ind3 - ind2 + 1) + 1):(ind3)) = tmplist1;
%         else
%             %2交换，两个序号数交换
%         ind1 = 0;
%         ind2 = 0;
%         while(ind1 == ind2)
%            ind1 = ceil(rand * amount);
%            ind2 = ceil(rand * amount);
%         end
%          tmp1 = sol_new(ind1);
%          sol_new(ind1) = sol_new(ind2);
%          sol_new(ind2) = tmp1;
%       end
      
    end
    
    %检查是否满足约束
  
    
    %计算目标函数值（即内能）
    for j=1:num
      E_new(j) = 0;
      for i = 1:(amount - 1)
          E_new(j)= E_new(j) + D(sol_new(j,i),sol_new(j,i + 1));
      end
    %再算上从最后一个城市到第一个城市的距离
      E_new(j)= E_new(j) + D(sol_new(j,amount),sol_new(j,1));
    end
    for i=1:num
      if E_new(i) <= E_current(i)
          E_current(i) = E_new(i);
          sol_current(i,:) = sol_new(i,:);
          if E_new(i) < E_best(i)
              E_best(i) = E_new(i);
              sol_best(i,:) = sol_new(i,:);
          end
      else
        %若新解的目标函数值大于当前解，
        %则仅以一定概率接受新解
          if rand < exp(-(E_new(i) - E_current(i))*1/t)  %加入修正系数100
              E_current(i) = E_new(i);
              sol_current(i,:) = sol_new(i,:);
              flag=flag+1;
          else
              sol_new(i,:) = sol_current(i,:);
          end
        
      end
    end
    
    %矩阵形式判断,有点问题
%     matrix=(E_new-E_current)<=0;
%     E_current=E_new*diag(matrix)+E_current*diag(-matrix+1);
%     sol_current =diag(matrix)* sol_new+diag(-matrix+1)*sol_current;
%     matrix=(E_new-E_best)<=0;
%     E_best=E_new*diag(matrix)+E_best*diag(-matrix+1);
%     sol_best =diag(matrix)* sol_new+diag(-matrix+1)*sol_best;
%     matrix=(rand(1,num)-exp(-(E_new - E_current).*100 ./t))<=0;
%     E_current = E_new*diag(matrix)+E_current*diag(-matrix+1);
%     sol_current =diag(matrix)* sol_new+diag(-matrix+1)*sol_current;
   
   end
   noft=noft+1;%降温次数
   E_bestofAll(noft)=min(E_best);%全局最优
   [~,pofAll]=min(E_best);
   sol_bestofAll(noft,:)=sol_best(pofAll,:);
   t = t * a;      %控制参数t（温度）减少为原来的a倍
   Markov_length=Markov_length*1.001;
end
%编码转换路径，默认从1开始
path=TSPpath_decode( sol_bestofAll(noft,:));
disp('最优解为:');
disp(path);
disp('最短距离:');
disp(E_bestofAll(noft));

figure(1)
P=city;N=amount;minplan=path;
plot(P(:,1),P(:,2),'ro');
hold on
for i=1:N-1
    line([P(minplan(i),1),P(minplan(i+1),1)],[P(minplan(i),2),P(minplan(i+1),2)]);
end
 line([P(minplan(1),1),P(minplan(N),1)],[P(minplan(1),2),P(minplan(N),2)]);
 for i=1:N
    str=sprintf('%d',i);
   text(P(i,1)+0.3,P(i,2),str);
 end

 figure(2)
 plot(E_bestofAll)