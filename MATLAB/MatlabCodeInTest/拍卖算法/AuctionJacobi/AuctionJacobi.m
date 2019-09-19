function [assignment prices] = AuctionJacobi(c)

% AUCTIONJACOBI Compute optimal assignement and optimal prices by Bertsekas
% algorithm. c is a matrix ; assignement is a vector giving the assigned
% column of a given row and the vector prices stores the prices of each
% column.

% This function returns altogether the optimal assignement and the dual
% prices relative to the cost function c, i.e it solves
% max c(1,sigma(1)) + ... + c(N,sigma(N)) where sigma is a permutation of
% {1,..,N} and c is a N-by-N matrix. The dual prices are the solution of
% min sum_j(v_j) + sum_i(Max_j(c_ij - v(i)))

% This is one of the numerous implementation of Pr. Dimitri Bertsekas' auction
% algorithm. Reference papers can be found on his page
% http://web.mit.edu/dimitrib/www/home.html

% Implemented by Damien Bosc (Ecole Polytechnique, France), last modified
% 9/7/09

N = length(c(:,1));

assignment = Inf * ones(1,N);

prices =  ones(1,N);

epsilon = 1;

iter = 1;


while (epsilon > 1 / N)
    assignment = Inf * ones(1,N);
    while(sum(isinf(assignment)))
        iter = iter + 1;
        [assignment, prices] = PerformRoundAuction(assignment, prices, c,epsilon);
    end
    
    %epsilon scaling as recommended by Bertsekas
    
    epsilon = epsilon * 0.25;
end

end

function [u, v] = PerformRoundAuction(assignment, prices, c, epsilon)

N = length(prices);

u = assignment;
v = prices;

unAssignedPeople = find(isinf(u));

temp = zeros(2, length(unAssignedPeople));

%compute and store the bids of each unsassigned individual in temp
for i = 1 : length(unAssignedPeople)
    value = c(unAssignedPeople(i),:) - v;
    [optimalValueForI , optimalObjectForI] = max(value);
    value(optimalObjectForI) = [];
    increment_i = optimalValueForI - max(value) + epsilon;
    temp(1,i) = optimalObjectForI;
    temp(2,i) = increment_i;
end

%each object which has received a bid determines the highest bidder and
%update its price accordingly
for j = 1 : N
    indices = find(temp(1,:) == j);
    if(~isempty(indices))
        [highestBidForJ, i_j] = max(temp(2,indices));

        index = find(u == j);
        if(~isempty(index))
            u(index(1)) = Inf;
        end
        u(unAssignedPeople(indices(i_j))) = j;
        v(j) = v(j) + highestBidForJ;
    end
end

end


