clear;
clc;
global P;
global NumCity;

P=[54, 67
54, 62
37, 84
41, 94
 2, 99
 7, 64
25, 62
22, 60
18, 54
 4, 50
13, 40
18, 40
24, 42
25, 38
44, 35
41, 26
45, 21
58, 35
62, 32
82,  7
91, 38
83, 46
71, 44
64, 60
68, 58
83, 69
87, 76
74, 78
71, 71
58, 69];
nvars=NumCity;
NumCity = size(P,1);
lb=ones(1,NumCity);
ub=NumCity*lb;
intcon=[1:NumCity];
load('options.mat');
%options = gaoptimset('ParetoFraction',0.3,'PopulationSize',1000,'Generations',200,'StallGenLimit',1000,'TolFun',1e-100);
[x,fval,exitflag,output,population,score] =ga(@GA_TSPfun,nvars,[],[],[],[],lb,ub,[],intcon,options);