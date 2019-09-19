clear;
clc;
global N;
global V01;
N=50;
Val=rand(N,N);
% Val=0.1*[7 1 1 7 4 7 6 7 8 5;
%     9 9 8 9 8 9 6 4 3 3;
%     3 7 0 9 1 3 6 5 4 8;
%     1 2 9 7 6 3 6 7 5 5;
%     8 1 6 7 4 9 4 5 7 8;
%     2 6 1 7 5 8 9 9 5 4;
%     4 6 7 10 4 9 10 3 4 7;
%     7 10 4 0 5 7 4 1 3 4;
%     1 4 3 7 5 0 5 9 8 7;
%     6 1 3 1 7 3 5 10 9 0];
V01=1-Val;
nvars=N;
lb=ones(1,N);
ub=9*ones(1,N);
intcon=1:N;
timeG1=clock;
[x,fval]=GA_run(nvars,lb,ub,intcon);
GA_plan=decode(x,N);
GAmaxval=sum(sum(Val.*codeVal2codeBool(GA_plan,N)));
timeG2=clock;

timeQ1=clock;
[Qplan_unique,~,fout,~] = minAssign( V01,10);
timeQ2=clock;

i=1;
timeG(i)=60*timeG2(5)-60*timeG1(5)+timeG2(6)-timeG1(6)
timeQ(i)=60*timeQ2(5)-60*timeQ1(5)+timeQ2(6)-timeQ1(6)
