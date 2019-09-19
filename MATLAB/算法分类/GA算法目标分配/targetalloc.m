function [ eval] = targetalloc( chrom )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(chrom);
p=[ 0.1370    0.5837    0.1199    0.6972    0.5060    0.5012    0.5078    0.9916    0.9396    0.0327    0.2817    0.8620    0.1767    0.0021    0.6350;...
    0.6246    0.2022    0.9324    0.2446    0.5865    0.8000    0.5380    0.6341    0.7435    0.8407    0.5944    0.5677    0.6935    0.7758    0.2260;...
    0.3092    0.1518    0.6332    0.8363    0.7256    0.5162    0.4264    0.2748    0.4422    0.1661    0.3226    0.9653    0.0669    0.3221    0.7049;...
    0.9459    0.3615    0.7752    0.8357    0.1556    0.8168    0.3461    0.5453    0.3218    0.0661    0.5325    0.5541    0.5317    0.9565    0.0565;...
    0.0162    0.1892    0.4130    0.2287    0.7525    0.8360    0.6881    0.6439    0.7436    0.7447    0.9467    0.9114    0.4127    0.5314    0.0887;...
    0.3860    0.2477    0.2143    0.4912    0.7296    0.1697    0.6714    0.8733    0.0506    0.2380    0.0671    0.1210    0.5263    0.2572    0.5258;...
    0.9447    0.8744    0.9117    0.8696    0.1896    0.4271    0.7155    0.9327    0.7611    0.2752    0.9196    0.9258    0.9483    0.6888    0.4285;...
    0.6776    0.5839    0.9055    0.2233    0.6662    0.3268    0.9249    0.7176    0.5112    0.5163    0.0441    0.4076    0.4953    0.9000    -0.9054];
w=[.47 .97 .76 .62 .48 .77 .33 .74 .54 .65 .43 .35 .63 .66 .57];
for i=1:m
    for j=1:15
        chrom(i,j)=p(chrom(i,j),j);
    end;
end
eval=chrom*w';

