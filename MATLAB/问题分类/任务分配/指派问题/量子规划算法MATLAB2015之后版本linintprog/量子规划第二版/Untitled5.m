N=1000;
Val=rand(N,N);%sËæ»ú²âÊÔ
Val=round(10000*Val)/10000;
[Qplan,EQplan]=minAssign(max(max(Val))-Val);
Qmaxval=sum(sum(Val.*codeVal2codeBool(Qplan,N)));
EQmaxval=sum(sum(Val.*EQplan));
