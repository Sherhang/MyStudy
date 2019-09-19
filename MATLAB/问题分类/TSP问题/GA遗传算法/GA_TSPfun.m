function Fitness = GA_TSPfun(chrom)
% Create City

Fitness = 0;

global P;
global NumCity;
for i=1:NumCity
    for j=1:NumCity
       Dist(i,j)=sqrt((P(i,1)-P(j,1))^2+(P(i,2)-P(j,2))^2);
    end
end

% Decode:
order = [];
city = 1 : NumCity;
for j = 1 : NumCity 
    order = [order, city(1+mod( chrom(j)-1, length(city)))];
    city(1 + mod(chrom(j)-1, length(city))) = [];
end
for i = 1 : NumCity
    city1 = order(i);
    city2 = order(1 + mod(i, NumCity));
    Fitness = Fitness + Dist((city1-1)*NumCity + city2);
end
end