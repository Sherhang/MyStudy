% [m1,n1]=find(e>0.1&e<0.75);
% for i=1:52
%     fenxi(i,1)=e(m1(i),n1(i));
%     fenxi(i,2)=Val(m1(i),n1(i));
% end
% fenxi1=sortrows(fenxi,1);
[mm1,nn1,~]=find(EQplan>0.1&EQplan<0.7);
[number,~]=size(mm1);
