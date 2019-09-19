% TSPģ���˻��㷨
 
    clear
    clc
    time1=clock;
    a = 0.9;       %�¶�˥�������Ĳ���
    t0 = 100;        %��ʼ�¶�
    tf = 0.1;         %��ֹ�¶�
    t = t0;
    Markov_length = 1000;  %Markov������
    N=50;
    Val=rand(N,N);
%     Val=0.1*[7 1 1 7 4 7 6 7 8 5;
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
    amount=size(Val,1);

 
sol_new = 1:amount;         %������ʼ�⣬sol_new��ÿ�β������½�
sol_current = sol_new;      %sol_current�ǵ�ǰ��
sol_best = sol_new;         %sol_best����ȴ�е���ý�
E_current = inf;            %E_current�ǵ�ǰ���Ӧ�Ļ�·����
E_best = inf;               %E_best�����Ž�
p = 1;
 
while t >= tf
   for r = 1:Markov_length      %Markov������
    %��������Ŷ�
    if(rand < 0.1)
        %������,��ͱ�׼���岻ͬ��ֻ����������λ��
        ind1 = 0;
        ind2 = 0;
        while(ind1 >= ind2)
           ind1 = ceil(rand * amount);
           ind2 = ceil(rand * amount);
        end
        tmp1 = sol_new(ind1);
        sol_new(ind1) = sol_new(ind2);
        sol_new(ind2) = tmp1;
    else
        %������
        ind1 = 0;
        ind2 = 0;
        ind3 = 0;
        while( (ind1 == ind2) || (ind1 == ind3) || (ind2 == ind3) || (abs(ind1 -ind2) == 1) )
            ind1 = ceil(rand * amount);%ceil����ȡ��
            ind2 = ceil(rand * amount);
            ind3 = ceil(rand * amount);
        end
        tmp1 = ind1;
        tmp2 = ind2;
        tmp3 = ind3;
        %ȷ�� ind1 < ind2 < ind3
        s=sort([ind1 ind2 ind3]);
        ind1=s(1);ind2=s(2);ind3=s(3);
%   ���������ϳ���ķ���������Ч�ʲ��
%         if(ind1 < ind2) && (ind2 < ind3);
%         elseif(ind1 < ind3) && (ind3 < ind2)
%             ind1 = tmp1; ind2 = tmp3; ind3 = tmp2;
%         elseif(ind2 < ind1) && (ind1 < ind3)
%             ind1 = tmp2; ind2 = tmp1; ind3 = tmp3;
%         elseif(ind2 < ind3) && (ind3 < ind1)
%             ind1 = tmp2; ind2 = tmp3; ind3 = tmp1;
%         elseif(ind3 < ind1) && (ind1 < ind2)
%             ind1 = tmp3; ind2 = tmp1; ind3 = tmp2;
%         elseif(ind3 < ind2) && (ind2 < ind1)
%             ind1 = tmp3; ind2 = tmp2; ind3 = tmp1;
%         end
        % ��������������ѡ���ı߽�
        tmplist1 = sol_new((ind1 + 1):(ind2 - 1));
        sol_new((ind1 + 1):(ind1 + (ind3 - ind2 + 1) )) = sol_new((ind2):(ind3));
        sol_new((ind1 + (ind3 - ind2 + 1) + 1):(ind3)) = tmplist1;
    end
    
    %����Ƿ�����Լ��
    
    %����Ŀ�꺯��ֵ�������ܣ�
   
    E_new=sum(sum(V01.*(codeVal2codeBool(sol_new,amount))));
   
    if E_new < E_current
        E_current = E_new;
        sol_current = sol_new;
        if E_new < E_best
            E_best = E_new;
            sol_best = sol_new;
        end
    else
        %���½��Ŀ�꺯��ֵ���ڵ�ǰ�⣬
        %�����һ�����ʽ����½�
        if rand < exp(-(E_new - E_current)*100/ t)
            E_current = E_new;
            sol_current = sol_new;
        else
            sol_new = sol_current;
        end
        
    end
   end
 
   t = t * a;      %���Ʋ���t���¶ȣ�����Ϊԭ����a��
end
time2=clock;

sol_best;
SAmax= sum(sum(Val.*(codeVal2codeBool(sol_best,amount))))
%��׼ֵ
[Qplan_unique,EQplan,Qminval,Qbad] = minAssign_mplan( V01,3);
Qplan_unique;
Qmax=sum(sum(Val.*(codeVal2codeBool(Qplan_unique(1,:),amount))))
SAmax
time=60*time2(5)-60*time1(5)+time2(6)-time1(6)