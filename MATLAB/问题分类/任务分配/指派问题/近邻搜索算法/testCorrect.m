%******���Ե������ӵ�׼ȷ��
clear
clc
n=30;
p=zeros(1,n);
p(1)=1;
for N=2:n
    main;
    p(N)=per;
    
    clearvars -EXCEPT p
   
end
plot(p,'bo');
hold on
x=1:30                                                                                      
y=polyfit(x,p,6);
Y=polyval(y,x);
plot(x,Y,'r')
xlabel('�����ģ');
ylabel('��������������');
legend('��������','�������');

