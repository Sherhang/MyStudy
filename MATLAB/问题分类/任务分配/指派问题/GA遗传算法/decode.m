function [ order ] = decode( chrom ,N)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
order = [];
work = 1 : N;
for j = 1 : N 
    order = [order, work(1+mod( chrom(j)-1, length(work)))];
    work(1 + mod(chrom(j)-1, length(work))) = [];
end

end

