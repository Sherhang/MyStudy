function [ f] = f_threat ( x1,y1,x2,y2,N)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
for i=1:N
        for j=1:N
%             f(i,j)=500000/sqrt((x1(i)-x2(j))^2+(y1(i)-y2(j))^2);
            l=sqrt((x1(i)-x2(j))^2+(y1(i)-y2(j))^2);
            if l>500000
                f(i,j)=0.1;
            else
                f(i,j)=0.9-0.8*l/500000;
            end
        end
end

end



