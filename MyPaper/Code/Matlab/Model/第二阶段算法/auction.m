% �����㷨��z���ָ������
% ����m*n��һ���������plan 2*n , ��һ�ж�ӦĿ�����У��ڶ��ж�Ӧִ��������
function plan = auction(matrix)
[m,n] = size(matrix);
% ����С����������������������ֵΪԭ��������ֵ
inf = max(max(matrix));
N = max(m,n);
mat = inf*ones(N,N);  % �¾���
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
% �������㷨
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
%     ��������
%   e
%     e is the epsilon - the minumum bet increase (default e = 1/(ngoods+1)
%     ֹͣ���, �㷨��֤��e��Χ�������Ž�
%     ) 
%     verbose �Ƿ���ʾ����
% outputs
%   won ���ŷ�����1*n����
%   bet ������Ʒ�۸�
%   happy �����
%   tt �㷨ִ��ʱ�䣬��λms
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
       w = rand(3,3)*10;  %�������
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
q   = 1:size(w,1);            % create queue for bidders (left - obs)��û�еõ���Ʒ���˵����

if (nargin<3)
    e = 1/(length(p)+1);
    e =0.1;
end

if (verbose)
    display('The percieved value of goods (top) by each bidder (left):');
    display([num2str(w, '%3.0f') ]);
end

i = find(q>0,1);              % take first non-committed bidder
ii = q(i);                    % û�о��ĵ���Ʒ���˵����
tdead = 0;
tic                           % ������ʱ��
flag=0; % ��������һ�������˶��ٴ�
while (~isempty(i) && (iter > 0))       %�������Ч
    flag = flag+1;
    q(q==ii) = 0;             % out of queue��q��1*n,ii��1*1,q==ii�õ�һ��1*n��0��1��q[i]==ii��λ������Ϊ0
    [v, j] = max(w(ii,:) - p); % search for good w greatest value 
                              % above current bid for bidder i����ʱbidder i�ľ�����Ʒ����j
    if ( ((w(ii,j) - (p(j) + e)) >= 0) && ...   
         ...                  % if our current bidder i values good j 
         ...                  % more than previous bidder plus epsilon 
         (won(j) ~= ii) )     % and the bot is not on himself already �����Ʒ��֮ǰ�ĳ�ͻ
        if (won(j)>0)
            k = find(q==0,1); % find first open bidder space,��һ���ǿյģ�
            q(k:(end-1)) = q((k+1):end);   % endָ����������������Զ��ģ�
                              % shift left and put ���k=[],��ô��仰ʲôҲ����
            q(end) = won(j);  % previous highest bidder back in the queue
        end
        won(j) = ii;          % assign current bidder i to good j
        p(j) = p(j) + e;      % and save the new bet
        
        % p���������¹�ʽ���ټ����������-�δ���������ָ����Ԫ��ֵ��ȥ�۸�
%         w_temp=w(ii,:);
%         w_temp=sort(w_temp,'descend')
%         profit_max=w_temp(1)-p(j);
%         profit_submax=w_temp(2)-p(j);
%         p(j)=p(j)+min(profit_max-profit_submax, e);
        % ��������  added by EE526 in 2019.5.25
        
        
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
% ����ԭ���ߺ���д���ˣ�Ӧ����iii��jjj��һ��,�Ѿ�������
% ������i �������ָi�����������0����Ʒ�Ϳ��ԣ������ڸ��У�ѡ�е���Ʒ��ֵ����e������
happy = won;
iown = find(won > 0);
for (ii = won(iown))     % won(iown) won�����д���0��ֵ��ɵ����飬һ�����won����,������ѭ����������ȡ
    iii = won(ii);       % iii 
    if (~isempty(iii))
        jjj = find(iii==won,1);   %jjj 
        if (~isempty(jjj))
            sum(e + w(jjj,iii) - p < w(jjj,:) - p);% �����ã����ִ�����б�ѡ�����ִ����Ŀ�����Ϊn-1��
                                                   % ����0˵��ѡ�е����ֲ��Ǹø������ġ�
            happy(jjj) = (sum(e + w(jjj,iii) - p < w(jjj,:) - p) == 0);%�ڸ��У�ѡ�е���Ʒ����e������
        end
    end
end
iown = find(won > 0);
for (ii = won(iown))
    iii = won(ii);
    happy(iii) = happy(iii) | (sum(w(iii,:) - p > 0)); %��һ�������Ǵ���0�ľ��������
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
display(['��������:' num2str(flag, '%d')]);