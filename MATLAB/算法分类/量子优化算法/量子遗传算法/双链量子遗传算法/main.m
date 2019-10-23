clear all;
close all;
%----------------变量-------------------
popsize = 100;
vartotal = 2;
shiftstep = 0.001*pi;   % 转角步长
Pm = ones(1,popsize)*0.05;  % 变异概率
maxgen = 500;
%---------------数组---------------------
varrange = 100*[-1 1; -1 1];  % 变量范围
%---------------染色体初始化------------
for i=1:vartotal
    fai(:,i) = 2*pi*rand(popsize,1);
    chrom(:,1,i) = cos(fai(:,i));
    chrom(:,2,i) = sin(fai(:,i));
    oldfai(:,i) = 2*pi*rand(popsize,1);
    oldchrom(:,1,i) = cos(oldfai(:,i));
    oldchrom(:,2,i) = sin(oldfai(:,i));
end
%--------------解空间变换---------------
for i=1:2
    for j=1:vartotal
        chromx(:,i,j)=0.5*(varrange(j,2)*(1+chrom(:,i,j))+varrange(j,1)*(1-chrom(:,i,j)));
        oldchromx(:,i,j)=0.5*(varrange(j,2)*(1+oldchrom(:,i,j))+varrange(j,1)*(1-oldchrom(:,i,j)));
    end
end
%------------计算适应度---------------
for i=1:popsize
    for j=1:2
        fitness(i,j) = getFitness(chromx(i,j,1), chromx(i,j,2));
        oldfitness(i,j) = getFitness(oldchromx(i,j,1),oldchromx(i,j,2));
    end
end
%------------获取最优解及相应的自变量-------------
[Bestf, Indexf] = sort(fitness,2); % 每行排序，小的在前
[BestF, IndexF] = sort(Bestf,1);   % 列排序
gBestfi = BestF(popsize,2) ;       % 适应度最大值
gBestp = IndexF(popsize,2);        % 最好的染色体号
gBestg = Indexf(gBestp,2);         % 最好基因链号
gBestfai = fai(gBestp,:);          % 最优染色体相位
gBestC = chrom(gBestp,:,:);        % 最优染色体
gBestx = chromx(gBestp,:,:);       % 最优染色体对应的解
gBestfit = fitness(gBestp,:);      % 最好的适应度

%------------主循环开始------------
for gen = 1:maxgen
    %-----------计算最大最小梯度----------
    for i = 1:vartotal
        tmp = abs(chromx(1,gBestg,i)-oldchromx(1,gBestg,i));
        if tmp < 1.0e-2
            tmp = 1.0e-2;
        end
        max(i) = abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp;
        min(i) = abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp;
        for j=1:popsize
            tmp = abs(chromx(j,gBestg,i)-oldchromx(j,gBestg,i));
            if tmp < 1.0e-2
                tmp = 1.0e-2;
            end
            if max(i) < abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp
                max(i) = abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp;
            end
            if min(i) > abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp
                min(i) = abs(fitness(1,gBestg)-oldfitness(1,gBestg))/tmp;
            end
        end
    end
    %-------------量子相位旋转-----------------
    for i=1:popsize
        for j=1:vartotal
            tmp = abs(chromx(i,gBestg,j)-oldchromx(i,gBestg,j));
            if tmp < 1.0e-2
                tmp = 1.0e-2;
            end
            grad = abs(fitness(i,gBestg)-oldfitness(i,gBestg))/tmp;
            tmp = abs(grad-min(j));
            if tmp < 1.0e-2
                tmp = 1.0e-2;
            end
            rate(i,j) = abs(max(j)-min(j))/tmp;
            fai(i,j) = fai(i,j) + sign(chrom(i,1,j)*gBestC(1,2,j)-gBestC(1,1,j)...
                *chrom(i,2,j))*rate(i,j)*shiftstep*exp(-gen/maxgen);
        end
    end
    %----------------执行量子相位变异---------------------
    randP = rand(popsize,vartotal);  % 生成随机数
    for i=1:popsize
        for j=1:vartotal
            if(Pm(i) > randP(i,j))&&(i~=gBestp)  % 非最优解概率变异
                fai(i,j)= 0.5*pi-fai(i,j);
            end
        end
    end
    %----------------代间复制---------------------
    oldchrom = chrom;
    oldchromx = chromx;
    oldfitness = fitness;
    %-------------生成新的染色体-------------------
    chrom(:,1,:) = cos(fai(:,:));
    chrom(:,2,:) = sin(fai(:,:));
    %------------解空间变换------------------
    for i=1:2
        for j=1:vartotal
            chromx(:,i,j)=0.5*(varrange(j,2)*(1+chrom(:,i,j))+varrange(j,1)*(1-chrom(:,i,j)));
        end
    end
    %--------------计算暗适应度-----------------
    for i=1:popsize
        for j=1:2
            fitness(i,j) = getFitness(chromx(i,j,1),chromx(i,j,2));
        end
    end
    %--------------获得最优解以及相应的自变量------------
    [Bestf, Indexf] = sort(fitness,2); % 每行排序，小的在前
    [BestF, IndexF] = sort(Bestf,1);   % 列排序
    Bestfi = BestF(popsize,2) ;       % 适应度最大值
    Bestp = IndexF(popsize,2);        % 最好的染色体号
    Bestg = Indexf(Bestp,2);         % 最好基因链号
    Bestfai = fai(Bestp,:);          % 最优染色体相位
    BestC = chrom(Bestp,:,:);        % 最优染色体
    Bestx = chromx(Bestp,:,:);       % 最优染色体对应的解
    Bestfit = fitness(Bestp,:);      % 最好的适应度
    
    Badp = IndexF(1,1);                % 最差染色体号
    %---------若最优解退化则取回上一代的最优解----------
    if Bestfi < gBestfi
        
    end
    %-----------若最优解进化则更新----------
    if Bestfi >= gBestfi
        gBestfi = Bestfi;
        gBestp = Bestp;
        gBestg = Bestg;
        gBestfai = Bestfai;
        gBestC = BestC;
        gBestx = Bestx;
        gBestfit = Bestfit;
    end
    %-----------记录优化结果----------------
    result(gen) = gBestfi;
    iteration(gen) = gen;
    %     fprintf('gen = %d\n', gen);
    if result(gen) > 0.999
        break;
    end
end
%------------程序主循环结束------------
%-------------画图-----------------
bestresult = result(gen);                                                                           
iterationstep = iteration(gen);
fprintf('bestresult = %d\n', bestresult);
fprintf('iterationstep = %d\n', iterationstep);
figure(1);
plot(iteration, result);


%-------------适应度函数-------------
function f = getFitness(x1,x2)
f = 0.5-((sin(sqrt(x1^2+x2^2)))^2-0.5)/(1+0.001*(x1^2+x2^2))^2;
end