
function [fBest,xBest] = TSPSA(city, t, a, tf, Markov_length)
% SA ��tsp, ����city��n*2) 
% �����̾��� fBest, ·��xBest

amount=size(city,1);
for i=1:amount
    for j=1:amount
        D(i,j)=((city(i,1)-city(j,1))^2+(city(i,2)-city(j,2))^2)^0.5;
    end
end


% a = 0.95;       %�¶�˥�������Ĳ���,һ������ȡ0.9����
% t0 = 100000;        %��ʼ�¶�
% tf = 0.01;         %��ֹ�¶�
% t = t0;
% Markov_length = 6000;  %Markov������

flag=0;

sol_new = 1:amount;         %������ʼ�⣬sol_new��ÿ�β������½�
sol_current = sol_new;      %sol_current�ǵ�ǰ��
sol_best = sol_new;         %sol_best����ȴ�е���ý�
E_current = inf;            %E_current�ǵ�ǰ���Ӧ�Ļ�·����
E_best = inf;               %E_best
p = 1;
tic;
while t >= tf
    for r = 1:Markov_length      %Markov������
        %��������Ŷ�
        if(rand < 0.5)
            %2�������������֮���������
            ind1 = 0;
            ind2 = 0;
            while(ind1 >= ind2)  %��֤1<2
                ind1 = ceil(rand * amount);
                ind2 = ceil(rand * amount);
            end
            %��������Ҫȷ��˳�򣬵��ǵ���ʱ����൱�ڲ����������Ч��
            %         c=[ind1;ind2];
            %         ind1=min(c);
            %         ind2=max(c);
            temp1=sol_new(ind1:ind2);
            temp1=fliplr(temp1);%����
            sol_new(ind1:ind2)=temp1;
        else
            %else if(rand<1)
            %������
            ind1 = 0;
            ind2 = 0;
            ind3 = 0;
            while( (ind1 == ind2) || (ind1 == ind3) || (ind2 == ind3) || (abs(ind1 -ind2) == 1) )
                ind1 = ceil(rand * amount);
                ind2 = ceil(rand * amount);
                ind3 = ceil(rand * amount);
            end
            tmp1 = ind1;
            tmp2 = ind2;
            tmp3 = ind3;
            %ȷ�� ind1 < ind2 < ind3
            s=sort([ind1 ind2 ind3]);
            ind1=s(1);ind2=s(2);ind3=s(3);
            tmplist1 = sol_new((ind1 + 1):(ind2 - 1));
            sol_new((ind1 + 1):(ind1 + (ind3 - ind2 + 1) )) = sol_new((ind2):(ind3));
            sol_new((ind1 + (ind3 - ind2 + 1) + 1):(ind3)) = tmplist1;
            
        end
        
        %����Ƿ�����Լ��
        
        
        %����Ŀ�꺯��ֵ�������ܣ�
        E_new = 0;
        for i = 1:(amount - 1)
            E_new = E_new + D(sol_new(i),sol_new(i + 1));
        end
        %�����ϴ����һ�����е���һ�����еľ���
        E_new = E_new + D(sol_new(amount),sol_new(1));
        
        if E_new <= E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            %���½��Ŀ�꺯��ֵ���ڵ�ǰ�⣬
            %�����һ�����ʽ����½�
            if rand < exp(-(E_new - E_current)*100 /t)  %��������ϵ��100
                E_current = E_new;
                sol_current = sol_new;
                flag=flag+1;
            else
                sol_new = sol_current;
            end
            
        end
    end
    
    t = t * a;      %���Ʋ���t���¶ȣ�����Ϊԭ����a��
end
toc
%����ת��·����Ĭ�ϴ�1��ʼ
xBest = TSPpath_decode( sol_best);
% disp('���Ž�Ϊ:');
% disp(path);
fBest = E_best;
end

function [ path ] =TSPpath_decode( path0 )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%  ·����1��ʼ���·����ʾ
[~,num] = size(path0);
[~,p1]=find(path0==1);
path(1:num-p1+1)=path0(p1:num);
path(num-p1+2:num)=path0(1:p1-1);
  if path(2)>path(num)
    temp1=path(2:num);
    temp1=fliplr(temp1);%����
    path(2:num)=temp1;
  end
end

