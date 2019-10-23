clear all;
close all;
%----------------����-------------------
popsize = 100;
vartotal = 2;
shiftstep = 0.001*pi;   % ת�ǲ���
Pm = ones(1,popsize)*0.05;  % �������
maxgen = 500;
%---------------����---------------------
varrange = 100*[-1 1; -1 1];  % ������Χ
%---------------Ⱦɫ���ʼ��------------
for i=1:vartotal
    fai(:,i) = 2*pi*rand(popsize,1);
    chrom(:,1,i) = cos(fai(:,i));
    chrom(:,2,i) = sin(fai(:,i));
    oldfai(:,i) = 2*pi*rand(popsize,1);
    oldchrom(:,1,i) = cos(oldfai(:,i));
    oldchrom(:,2,i) = sin(oldfai(:,i));
end
%--------------��ռ�任---------------
for i=1:2
    for j=1:vartotal
        chromx(:,i,j)=0.5*(varrange(j,2)*(1+chrom(:,i,j))+varrange(j,1)*(1-chrom(:,i,j)));
        oldchromx(:,i,j)=0.5*(varrange(j,2)*(1+oldchrom(:,i,j))+varrange(j,1)*(1-oldchrom(:,i,j)));
    end
end
%------------������Ӧ��---------------
for i=1:popsize
    for j=1:2
        fitness(i,j) = getFitness(chromx(i,j,1), chromx(i,j,2));
        oldfitness(i,j) = getFitness(oldchromx(i,j,1),oldchromx(i,j,2));
    end
end
%------------��ȡ���Ž⼰��Ӧ���Ա���-------------
[Bestf, Indexf] = sort(fitness,2); % ÿ������С����ǰ
[BestF, IndexF] = sort(Bestf,1);   % ������
gBestfi = BestF(popsize,2) ;       % ��Ӧ�����ֵ
gBestp = IndexF(popsize,2);        % ��õ�Ⱦɫ���
gBestg = Indexf(gBestp,2);         % ��û�������
gBestfai = fai(gBestp,:);          % ����Ⱦɫ����λ
gBestC = chrom(gBestp,:,:);        % ����Ⱦɫ��
gBestx = chromx(gBestp,:,:);       % ����Ⱦɫ���Ӧ�Ľ�
gBestfit = fitness(gBestp,:);      % ��õ���Ӧ��

%------------��ѭ����ʼ------------
for gen = 1:maxgen
    %-----------���������С�ݶ�----------
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
    %-------------������λ��ת-----------------
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
    %----------------ִ��������λ����---------------------
    randP = rand(popsize,vartotal);  % ���������
    for i=1:popsize
        for j=1:vartotal
            if(Pm(i) > randP(i,j))&&(i~=gBestp)  % �����Ž���ʱ���
                fai(i,j)= 0.5*pi-fai(i,j);
            end
        end
    end
    %----------------���临��---------------------
    oldchrom = chrom;
    oldchromx = chromx;
    oldfitness = fitness;
    %-------------�����µ�Ⱦɫ��-------------------
    chrom(:,1,:) = cos(fai(:,:));
    chrom(:,2,:) = sin(fai(:,:));
    %------------��ռ�任------------------
    for i=1:2
        for j=1:vartotal
            chromx(:,i,j)=0.5*(varrange(j,2)*(1+chrom(:,i,j))+varrange(j,1)*(1-chrom(:,i,j)));
        end
    end
    %--------------���㰵��Ӧ��-----------------
    for i=1:popsize
        for j=1:2
            fitness(i,j) = getFitness(chromx(i,j,1),chromx(i,j,2));
        end
    end
    %--------------������Ž��Լ���Ӧ���Ա���------------
    [Bestf, Indexf] = sort(fitness,2); % ÿ������С����ǰ
    [BestF, IndexF] = sort(Bestf,1);   % ������
    Bestfi = BestF(popsize,2) ;       % ��Ӧ�����ֵ
    Bestp = IndexF(popsize,2);        % ��õ�Ⱦɫ���
    Bestg = Indexf(Bestp,2);         % ��û�������
    Bestfai = fai(Bestp,:);          % ����Ⱦɫ����λ
    BestC = chrom(Bestp,:,:);        % ����Ⱦɫ��
    Bestx = chromx(Bestp,:,:);       % ����Ⱦɫ���Ӧ�Ľ�
    Bestfit = fitness(Bestp,:);      % ��õ���Ӧ��
    
    Badp = IndexF(1,1);                % ���Ⱦɫ���
    %---------�����Ž��˻���ȡ����һ�������Ž�----------
    if Bestfi < gBestfi
        
    end
    %-----------�����Ž���������----------
    if Bestfi >= gBestfi
        gBestfi = Bestfi;
        gBestp = Bestp;
        gBestg = Bestg;
        gBestfai = Bestfai;
        gBestC = BestC;
        gBestx = Bestx;
        gBestfit = Bestfit;
    end
    %-----------��¼�Ż����----------------
    result(gen) = gBestfi;
    iteration(gen) = gen;
    %     fprintf('gen = %d\n', gen);
    if result(gen) > 0.999
        break;
    end
end
%------------������ѭ������------------
%-------------��ͼ-----------------
bestresult = result(gen);                                                                           
iterationstep = iteration(gen);
fprintf('bestresult = %d\n', bestresult);
fprintf('iterationstep = %d\n', iterationstep);
figure(1);
plot(iteration, result);


%-------------��Ӧ�Ⱥ���-------------
function f = getFitness(x1,x2)
f = 0.5-((sin(sqrt(x1^2+x2^2)))^2-0.5)/(1+0.001*(x1^2+x2^2))^2;
end