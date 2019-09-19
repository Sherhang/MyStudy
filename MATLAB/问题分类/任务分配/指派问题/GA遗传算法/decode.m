function [ order ] = decode( chrom ,N)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
order = [];
work = 1 : N;
for j = 1 : N 
    order = [order, work(1+mod( chrom(j)-1, length(work)))];
    work(1 + mod(chrom(j)-1, length(work))) = [];
end

end

