%��׼Grover�㷨�ɹ��������/2�����㷨�ĳɹ����ʶԱ�
clear all;
close all;
%���̬��״̬�����ı�ֵ
t = 0.001:0.001:1;
%��׼Grover�㷨��������
r = round(acos(sqrt(t))./(2*asin(sqrt(t))));
%��׼Grover�㷨�ĳɹ�����
P = sin((2*r+1).*asin(sqrt(t))).^2;
%��t > 1/3����ת��λΪ��/2ʱ������һ���������㷨�ĳɹ�����
P1 = 4*t.^3-8*t.^2 + 5*t;
plot(t, P,'r', t, P1,'b')
legend("��׼Grover�㷨","һ������");
grid on