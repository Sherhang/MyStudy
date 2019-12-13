% 拍卖算法求z最大化指派问题
% 输入m*n的一个矩阵，输出plan 2*n , 第一行对应目标序列，第二行对应执行体序列
function plan = auction(matrix)
[m,n] = size(matrix);
% 列数小于行数，扩充列数，扩充值为原矩阵的最大值
inf = max(max(matrix));
N = max(m,n);
mat = inf*ones(N,N);  % 新矩阵
if m < n
    mat(1:m,:) = matrix;
end
if m > n
    mat(:,1:n) = matrix;
end
plan = zeros(2,max(m,n));
plan(2,i) = auction(mat);
if m < n   
    for i=1:n
        if plan(2,i) > m
            plan(2,i) = 0;
        end
    end
end
if m > n
    for i=1:m
        if plan(1,i) > n
            plan(1,i) = 0;
        end
    end
    plan = plan(:,1:n);
end

end



function [ won bet happy tt ] = auction1( w, iter, e, verbose )
% Subroutine AUCTION is a implemetation of the auction Algorithm 
% 子拍卖算法
% presented in Turing's Invisible Hand. Although well discribed the 
% pseudo-algorithm presented there contained an error which was corrected 
% by line 62-65 replacing 
%           if ((w(ii,j) - p(j)) >= 0)
%
% [ won bet happiness ] = auction( w, iter, e, verbose )
% Inputs:
%   w (g x b) 
%     the rows is the bidders
%     the cols is the goods
%     the values are every bidder i's percieved value of good j 
%   iter 
%     iterations iterations to do
%     迭代次数
%   e
%     e is the epsilon - the minumum bet increase (default e = 1/(ngoods+1)
%     停止误差, 算法保证在e误差范围内是最优解
%     ) 
%     verbose 是否显示过程
% outputs
%   won 最优方案，1*n数组
%   bet 最终物品价格
%   happy 满意度
%   tt 算法执行时间，单位ms
%
% Copyright (C) 2012 - Pieter V. Reyneke, South Africa
%
% Open Source licence, use whereever you like but at own risk, keep this
% complete copyright notice in the code and please send me updates and 
% report errors to pieter.reyneke@gmail.com. Will give recognition, if
% requested, after any valid comment leading to an update was recieved. 
%
% Author: PV Reyneke

if (nargin<1)
    
    w = [0.7 0.1 0.1  0.7 0.4 0.7  0.6 0.7 0.8 0.5;
     	   0.9 0.9 0.8  0.9 0.8 0.9  0.6 0.4 0.3 0.3;
		   0.3 0.7 0    0.9 0.1 0.3  0.6 0.5 0.4 0.8;
           0.1 0.2 0.9  0.7 0.6 0.3   0.6 0.7 0.5 0.5;
           0.8 0.1 0.6  0.7 0.4 0.9   0.4 0.5 0.7 0.8;
           0.2 0.6 0.1  0.7 0.5 0.8   0.9 0.9 0.5 0.4;
           0.4 0.6 0.7  1 0.4 0.9     1 0.3 0.4 0.7;
           0.7 1 0.4    0 0.5 0.7    0.4 0.1 0.3 0.4;
           0.1 0.4 0.3   0.7 0.5 0   0.5 0.9 0.8 0.7;
           0.6 0.1 0.3   0.1 0.7 0.3   0.5 1 0.9 0;];
       w = rand(3,3)*10;  %随机测试
      % w=[4  3  4;1  4  4;4  8  4];

       
end

if (nargin<2)
    iter = Inf;
end

if (nargin<4)
    verbose = 1;
end

p   = zeros(1,size(w,2));     % reset all goods' current bets (top - tracks)
won = zeros(1,size(w,2));     % reset cuurent winners for each good
q   = 1:size(w,1);            % create queue for bidders (left - obs)还没有得到物品的人的序号

if (nargin<3)
    e = 1/(length(p)+1);
    e =0.1;
end

if (verbose)
    display('The percieved value of goods (top) by each bidder (left):');
    display([num2str(w, '%3.0f') ]);
end

i = find(q>0,1);              % take first non-committed bidder
ii = q(i);                    % 没有竞拍到物品的人的序号
tdead = 0;
tic                           % 启动计时器
flag=0; % 计数器，一共迭代了多少次
while (~isempty(i) && (iter > 0))       %当序号有效
    flag = flag+1;
    q(q==ii) = 0;             % out of queue，q是1*n,ii是1*1,q==ii得到一个1*n的0，1，q[i]==ii的位置设置为0
    [v, j] = max(w(ii,:) - p); % search for good w greatest value 
                              % above current bid for bidder i，此时bidder i的竞拍物品就是j
    if ( ((w(ii,j) - (p(j) + e)) >= 0) && ...   
         ...                  % if our current bidder i values good j 
         ...                  % more than previous bidder plus epsilon 
         (won(j) ~= ii) )     % and the bot is not on himself already 如果物品和之前的冲突
        if (won(j)>0)
            k = find(q==0,1); % find first open bidder space,第一次是空的，
            q(k:(end-1)) = q((k+1):end);   % end指数组最大索引，是自动的，
                              % shift left and put 如果k=[],那么这句话什么也不做
            q(end) = won(j);  % previous highest bidder back in the queue
        end
        won(j) = ii;          % assign current bidder i to good j
        p(j) = p(j) + e;      % and save the new bet
        
        % p的其他更新公式，再加上最大利润-次大利润，利润指矩阵元素值减去价格
%         w_temp=w(ii,:);
%         w_temp=sort(w_temp,'descend')
%         profit_max=w_temp(1)-p(j);
%         profit_submax=w_temp(2)-p(j);
%         p(j)=p(j)+min(profit_max-profit_submax, e);
        % 添加项结束  added by EE526 in 2019.5.25
        
        
    end
    
    if (verbose)
        tsss = toc;
        display(['Bets(in epsilons)  : ' num2str(p, '%.1f  ') ]);
        display(['Bidder             : ' num2str(won, '%.0f ') ]);
        display(['Left todo          : ' num2str(q, '%3.0f') ]);
        display(['-----------------------------------------' ]);
        tdead = toc - tsss;
    end
    i = find(q>0,1);          % take next non-committed bidder
    ii = q(i);
    iter = iter-1;
end
bet = p;
tt = toc;

% measuring each bidder's happiness (the invariant of above loop)
% 这里原作者好像写反了，应该是iii和jjj换一下,已经修正。
% 竞拍者i 的满意度指i行有利润大于0的物品就可以，或者在该行，选中的物品价值加上e是最大的
happy = won;
iown = find(won > 0);
for (ii = won(iown))     % won(iown) won数组中大于0的值组成的数组，一般就是won本身,这里是循环，会依次取
    iii = won(ii);       % iii 
    if (~isempty(iii))
        jjj = find(iii==won,1);   %jjj 
        if (~isempty(jjj))
            sum(e + w(jjj,iii) - p < w(jjj,:) - p);% 调试用，数字代表该行比选中数字大的数目，最大为n-1。
                                                   % 大于0说明选中的数字不是该该行最大的。
            happy(jjj) = (sum(e + w(jjj,iii) - p < w(jjj,:) - p) == 0);%在该行，选中的物品加上e是最大的
        end
    end
end
iown = find(won > 0);
for (ii = won(iown))
    iii = won(ii);
    happy(iii) = happy(iii) | (sum(w(iii,:) - p > 0)); %有一个利润是大于0的就是满意的
end

j = 1;
cost = 0;
for (i=won)
    cost = cost + w(i,j);
    j = j+1;
end


if (verbose)
    display(['Assignment Cost    : ' num2str(cost, '%5.3f') ]);
    display(['Happiness          : ' num2str(happy, '%3.0f') ]);
    display(['Calc took          : ' num2str((tt - tdead) * 1000, '%5.3f') ' ms' ]);
end
display(['迭代次数:' num2str(flag, '%d')]);