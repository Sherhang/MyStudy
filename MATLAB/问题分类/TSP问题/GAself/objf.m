function [f,p]=objf(s,dislist)
%����������Ⱥ����Ӧ�� 
%���룬��Ⱥ��ÿһ����һ�����壬���о������
%�����f��Ӧ�ȣ�ÿ�������ѡ�����

inn=size(s,1);  %��ȡ��Ⱥ��С
d=zeros(1,inn);
for i=1:inn
   d(i)=CalDist(dislist,s(i,:));  %�������
end
f=1000./d.^100; %��Ӧ�Ⱥ���,
%���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���
fsum=sum(f);
p=zeros(1,inn);
for i=1:inn
   p(i)=f(i)/fsum;
end
 
end
