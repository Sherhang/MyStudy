function [x,fval,exitflag,output,population,score] = GA_main(nvars,lb,ub,intcon,StallGenLimit_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'StallGenLimit', StallGenLimit_Data);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv });
[x,fval,exitflag,output,population,score] = ...
ga(@GA_TSPfun,nvars,[],[],[],[],lb,ub,[],intcon,options);
