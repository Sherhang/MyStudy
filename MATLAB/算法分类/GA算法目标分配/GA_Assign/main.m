clear;
clc;
global N;
global V01;
N=10;
Val=rand(N,N);
V01=1-Val;

nvars=N;
lb=ones(1,N);
ub=9*ones(1,N);
intcon=1:N;
timeG1=clock;
[x,fval]=GA_run(nvars,lb,ub,intcon);
GA_plan=decode(x,N)
timeG2=clock;

timeQ1=clock;
[Qplan_unique,~,fout,~] = minAssign( V01,10);
timeQ2=clock;

i=1;
timeG(i)=60*timeG2(5)-60*timeG1(5)+timeG2(6)-timeG1(6)
timeQ(i)=60*timeQ2(5)-60*timeQ1(5)+timeQ2(6)-timeQ1(6)
