figure(1)
N=3;

a=[0.9 0.05 0.05;
    0.2 0.5 0.3;
    0.3 0.4 0.3;];

for i=1:N
    for j=1:N
        x=i+0.2*(randn(1,a(i,j)*5000));%²úÉú°×ÔëÉù
        y=j+0.2*(randn(1,a(i,j)*5000));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
        