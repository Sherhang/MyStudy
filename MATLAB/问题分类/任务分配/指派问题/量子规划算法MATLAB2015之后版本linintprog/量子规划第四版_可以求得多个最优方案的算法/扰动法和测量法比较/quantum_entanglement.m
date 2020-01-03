
N=3;%½×Êı
for i=1:N
    for j=1:N
        x(N*i-N+j)=i;
    end
end
x1=x;
clear x;
%
for i=1:N
    x(i)=i;
end
x2=repmat(x,1,N);
clear x;
y1=x1;y2=x2;

near=zeros(N*N,N*N);
for i=1:N*N
    for j=1:N*N
        if (y1(i)==x1(j))||(y2(i)==x2(j))
            near(i,j)=1;
        end
    end
end

for i=1:N*N
    near(i,i)=0;
end
%
M=N*N;
figure(1);
title('n=3');
set(gcf,'color','w');
for i=1:M
    for j=1:M
         x=i+0.05*(randn(1,round(near(i,j)*1500)));%²úÉú°×ÔëÉù
         y=j+0.05*(randn(1,round(near(i,j)*1500)));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 M+1 0 M+1]);
xlabel('x');ylabel('y');
grid on