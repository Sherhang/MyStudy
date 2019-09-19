clear
clc
for k=1:100
    GA;
    a(:,k)=trace(:,1);
    b(:,k)=trace(:,2);
end
a=a';
b=b';
A=mean(a);
B=mean(b);
A=A';
B=B';
plot(A,'r')
hold on
plot(B)
grid
legend('适应值','种群均值')
[Y,I]=max(ObjV); Chrom(I,:),Y 

    