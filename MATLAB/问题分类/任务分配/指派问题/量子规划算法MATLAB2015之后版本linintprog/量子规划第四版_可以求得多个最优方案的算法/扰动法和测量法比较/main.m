clc;clear;
N=10;
%************* ��в��������˸���
    Fx=200000*rand(1,N)';
    Fy=200000*rand(1,N)';
   
    Tx=200000*rand(1,N)';
    Ty=200000*rand(1,N)';
    pro=f_probility(Fx,Fy,Tx,Ty,N);
    thr=f_threat(Fx,Fy,Tx,Ty,N);
    thr1=max(thr);
    thr=repmat(thr1,N,1);
    Val=pro.*thr;
    Val=rand(N,N);%s�������
    Val=round(10*Val)/10;%����С��5λ
    V01=Val/max(max(Val));%�����׼��0-1��Χ
%   Val(find(Val>0.975))=0.975;  %��Ϊ����̶�̮����������������
%   Val(find(Val<0.1))=0.1;
% ����������
for i=1:N
    for j=1:N
       D(i,j)=sqrt((Fx(i)-Tx(j))^2+(Fy(i)-Ty(j))^2);
    end
end
d01=D/max(max(D));


[Qplan_unique_noise,~,Qminval_noise0,Qbad_noise] = minAssign_mplan(1-V01,10);%�Ŷ���
Qminval_noise=sum(sum(Val.*codeVal2codeBool(Qplan_unique_noise(1,:),N)));
[plan_unique,EQplan,minval0,cou] = minAssign( 1-V01,1);%����ģ�⣬������
minval=sum(sum(Val.*codeVal2codeBool(plan_unique(1,:),N)));
    
for i=1:10
    [Bplan,Bminval0]=minBzp(1-V01);
    Bplan_store(i,:)=Bplan;
    Bplan_unique=unique(Bplan_store,'rows');
end
Bminval=sum(sum(Val.*codeVal2codeBool(Bplan_unique(1,:),N)));

fprintf('�����㷨����ֵΪ��%f %f %f\n',Qminval_noise,minval,Bminval);

[num1,~]=size(Qplan_unique_noise);
fprintf('10���������ŷ��ҳ�������Ϊ%d\n',num1);
[num2,~]=size(plan_unique);
fprintf('1�����Ӳ������ҳ�������Ϊ%d\n',num2);
[num3,~]=size(Bplan_unique);
fprintf('10�η�֧���編�ҳ�������Ϊ%d\n',num3);

figure(3);%������ͼ

title('������ͼ');
set(gcf,'color','w');
%figure('color',[1 1 1]);
for i=1:N
    for j=1:N
        x=i+0.4*(randn(1,round(EQplan(i,j)*800)));%����������
        y=j+0.4*(randn(1,round(EQplan(i,j)*800)));
        plot(x,y,'r.','markersize',1);
        hold on
    end
end
axis([0 N+1 0 N+1]);
grid on

