function [f] =f_probility( x1,y1,x2,y2,N)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明\
% x1=Fx';
% y1=Fy';
% x2=Tx';
% y2=Ty';
for i=1:N
        for j=1:N
%             f(i,j)=500000/sqrt((x1(i)-x2(j))^2+(y1(i)-y2(j))^2);
            l=sqrt((x1(i)-x2(j))^2+(y1(i)-y2(j))^2);
            if l>50000
                f(i,j)=0.2*50000/l+0.6;
            else
                f(i,j)=0.8;
            end
        end
end

end

