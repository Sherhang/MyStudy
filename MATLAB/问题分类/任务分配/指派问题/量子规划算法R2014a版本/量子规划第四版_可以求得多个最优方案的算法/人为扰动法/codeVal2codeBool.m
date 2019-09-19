function [plan] = codeVal2codeBool( v,N )
%UNTITLED2 s实值编码到01编码
%   v是导弹编码。目标默认123456...
    plan(:,:)=zeros(N);
    for i=1:N
        plan(v(i),i)=1;
    end
end

