%% 双心点决策
Fox=mean(Fx);
Foy=mean(Fy);
Foz=mean(Fz);
Tox=mean(Tx);
Toy=mean(Ty);
Toz=mean(Tz);

pro1=500000./sqrt((Fx-Tox).^2+(Fy-Toy).^2+(Fz-Toz).^2);
threat1=500000./sqrt((Tx-Fox).^2+(Ty-Foy).^2+(Tz-Foz).^2);
%threat1=threat(1,:)';
[temp,DTsort]=sort(threat1,'descend');
[temp,DMsort]=sort(pro1,'descend');
temp=sortrows([DMsort,DTsort],2);
Dplan=temp(:,1)';
[~,dp,~]=intersect(c,Dplan,'rows'); % 位置
dplan(:,:)=codeVal2codeBool(Dplan,N);
Dmaxval(t)=sum(sum(pro.*threat.*dplan));