function map=mmap(s,e,m,w)

% m1=s(1):(e(1)-s(1))/10:e(1);
% m2=s(2):(e(2)-s(2))/10:e(2);

m1=linspace(s(1),e(1),abs((e(1)-s(1))*3));
m2=linspace(s(2),e(2),abs((e(2)-s(2))*3));
m3=max(length(m1),length(m2));
m1=linspace(s(1),e(1),m3);
m2=linspace(s(2),e(2),m3);
map=m;
for i1=1:length(m1)
    map=[map; m1(i1) m2(i1) w];
end