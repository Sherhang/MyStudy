function [plan] = codeVal2codeBool( v,N )
%UNTITLED2 sʵֵ���뵽01����
%   v�ǵ������롣Ŀ��Ĭ��123456...
    plan(:,:)=zeros(N);
    for i=1:N
        plan(v(i),i)=1;
    end
end

