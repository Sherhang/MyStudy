function [x,fval,exitflag,output,population,score] = GA_run(nvars,lb,ub,intcon)

global N;

options = gaoptimset;

options = gaoptimset(options,'CreationFcn', @gacreationuniform);
options = gaoptimset(options,'CrossoverFcn', @crossoverscattered);
options = gaoptimset(options,'MutationFcn', {  @mutationuniform [] });
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'Generation', 100*N);
[x,fval,exitflag,output,population,score] = ...
ga(@GA_fitness,nvars,[],[],[],[],lb,ub,[],intcon,options);
