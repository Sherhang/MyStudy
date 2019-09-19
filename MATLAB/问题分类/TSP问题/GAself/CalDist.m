function D=CalDist(dislist,path)
% ¼ÆËãÂ·¾¶¾àÀë
%ÊäÈëdislist,path
D=0;
n=size(path,2);
for i=1:(n-1)
    D=D+dislist(path(i),path(i+1));
end
D=D+dislist(path(n),path(1));

end
