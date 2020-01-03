function ga_TSP
clear;clc;
% mainly amended by Chen Zhen, 2012~2016
 
CityNum=30; %you chan choose 10, 30, 50, 75
[dislist,Clist]=tsp(CityNum);
 
inn=30; %��ʼ��Ⱥ��С
gnmax=CityNum*10;  %������
pc=0.8; %�������
pm=0.8; %�������
 
%������ʼ��Ⱥ
s=zeros(inn,CityNum);
for i=1:inn
    s(i,:)=randperm(CityNum);%���������������
end
[~,p]=objf(s,dislist);
 
gn=1;
ymean=zeros(gn,1);
ymax=zeros(gn,1);
xmax=zeros(inn,CityNum);
scnew=zeros(inn,CityNum);
smnew=zeros(inn,CityNum);
while gn<gnmax+1
   for j=1:2:inn
      seln=sel(p);  %ѡ�����
      scro=cro(s,seln, );  %�������
      scnew(j,:)=scro(1,:);
      scnew(j+1,:)=scro(2,:);
      smnew(j,:)=mut(scnew(j,:),pm);  %�������
      smnew(j+1,:)=mut(scnew(j+1,:),pm);
   end
   s=smnew;  %�������µ���Ⱥ
   [f,p]=objf(s,dislist);  %��������Ⱥ����Ӧ��
   %��¼��ǰ����ú�ƽ������Ӧ��
   [fmax,nmax]=max(f);
   ymean(gn)=1000/mean(f);
   ymax(gn)=1000/fmax;
   %��¼��ǰ������Ѹ���
   x=s(nmax,:);
   xmax(gn,:)=x;
   drawTSP(Clist,x,ymax(gn),gn,0);
   gn=gn+1;
end
[min_ymax,index]=min(ymax);
drawTSP(Clist,xmax(index,:),min_ymax,index,1);
 
figure(2);
plot(ymax,'r'); hold on;
plot(ymean,'b');grid;
title('��������');
legend('���Ž�','ƽ����');
fprintf('�Ŵ��㷨�õ�����̾���:%.2f\n',min_ymax);
fprintf('�Ŵ��㷨�õ������·��');
disp(xmax(index,:));
end
 
%------------------------------------------------
%����������Ⱥ����Ӧ��
function [f,p]=objf(s,dislist)
 
inn=size(s,1);  %��ȡ��Ⱥ��С
f=zeros(inn,1);
for i=1:inn
   f(i)=CalDist(dislist,s(i,:));  %���㺯��ֵ������Ӧ��
end
f=1000./f'; %ȡ���뵹��
%���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���
fsum=0;
for i=1:inn
   fsum=fsum+f(i)^15;% ����Ӧ��Խ�õĸ��屻ѡ�����Խ��
end
ps=zeros(inn,1);
for i=1:inn
   ps(i)=f(i)^15/fsum;
end
 
p=ps;
end
 
%--------------------------------------------------
%���ݱ�������ж��Ƿ����%����Ҫ�ⲿ��
function pcc=pro(pc)
test(1:100)=0;
l=round(100*pc);
test(1:l)=1;
n=round(rand*99)+1;
pcc=test(n);   
end
 
%--------------------------------------------------
%��ѡ�񡱲���
function seln=sel(p)
%ѡ��������Ⱥÿ�������ѡ���������p,���̶�,�������ŽⱣ������
num=2;
seln=zeros(1,num);
[~,pmax]=max(p);
%���ŽⱣ��
seln(1)=pmax;
p(pmax)=0;
%����Ⱥ��ѡ����������
for n=2:num
    r=rand;t=1;
    p=p/sum(p);
    s=p(1);
    while(1)
       if r<=s
           break;
       end
       t=t+1;
       s=s+p(t);
    end
    seln(n)=t;
    p(t)=0;%��ֹѡͬһ��r
 
end
end
 
%------------------------------------------------
%�����桱����
function scro=cro(s,seln,pc)
 
bn=size(s,2);
pcc=pro(pc);  %���ݽ�����ʾ����Ƿ���н��������1���ǣ�0���
scro(1,:)=s(seln(1),:);
scro(2,:)=s(seln(2),:);
if pcc==1
   c1=round(rand*(bn-2))+1;  %��[1,bn-1]��Χ���������һ������λ
   c2=round(rand*(bn-2))+1;
   chb1=min(c1,c2);
   chb2=max(c1,c2);
   middle=scro(1,chb1+1:chb2);
   scro(1,chb1+1:chb2)=scro(2,chb1+1:chb2);
   scro(2,chb1+1:chb2)=middle;
   for i=1:chb1 %�ƺ�������
       while find(scro(1,chb1+1:chb2)==scro(1,i))
           zhi=find(scro(1,chb1+1:chb2)==scro(1,i));
           y=scro(2,chb1+zhi);
           scro(1,i)=y;
       end
       while find(scro(2,chb1+1:chb2)==scro(2,i))
           zhi=find(scro(2,chb1+1:chb2)==scro(2,i));
           y=scro(1,chb1+zhi);
           scro(2,i)=y;
       end
   end
   for i=chb2+1:bn
       while find(scro(1,1:chb2)==scro(1,i))
           zhi=logical(scro(1,1:chb2)==scro(1,i));
           y=scro(2,zhi);
           scro(1,i)=y;
       end
       while find(scro(2,1:chb2)==scro(2,i))
           zhi=logical(scro(2,1:chb2)==scro(2,i));
           y=scro(1,zhi);
           scro(2,i)=y;
       end
   end
end
end
 
%--------------------------------------------------
%�����족����
function snnew=mut(snew,pm)
 
bn=size(snew,2);
snnew=snew;
 
pmm=pro(pm);  %���ݱ�����ʾ����Ƿ���б��������1���ǣ�0���
if pmm==1
   c1=round(rand*(bn-2))+1;  %��[1,bn-1]��Χ���������һ������λ
   c2=round(rand*(bn-2))+1;
   chb1=min(c1,c2);
   chb2=max(c1,c2);
   x=snew(chb1+1:chb2);
   snnew(chb1+1:chb2)=fliplr(x);
end
end
 
%------------------------------------------------
%����λ������
function [DLn,cityn]=tsp(n)
DLn=zeros(n,n);
if n==10
    city10=[0.4 0.4439;0.2439 0.1463;0.1707 0.2293;0.2293 0.761;0.5171 0.9414;
        0.8732 0.6536;0.6878 0.5219;0.8488 0.3609;0.6683 0.2536;0.6195 0.2634];%10 cities d'=2.691
    for i=1:10
        for j=1:10
            DLn(i,j)=((city10(i,1)-city10(j,1))^2+(city10(i,2)-city10(j,2))^2)^0.5;
        end
    end
    cityn=city10;
end

if n==20
    city20=rand(2,20)';
    for i=1:20
        for j=1:20
            DLn(i,j)=((city20(i,1)-city20(j,1))^2+(city20(i,2)-city20(j,2))^2)^0.5;
        end
    end
    cityn=city20;
end

if n==30
    city30=[54, 67
54, 62
37, 84
41, 94
 2, 99
 7, 64
25, 62
22, 60
18, 54
 4, 50
13, 40
18, 40
24, 42
25, 38
44, 35
41, 26
45, 21
58, 35
62, 32
82,  7
91, 38
83, 46
71, 44
64, 60
68, 58
83, 69
87, 76
74, 78
71, 71
58, 69];
%     city30=[41 94;37 84;54 67;25 62;7 64;2 99;68 58;71 44;54 62;83 69;64 60;18 54;22 60;
%         83 46;91 38;25 38;24 42;58 69;71 71;74 78;87 76;18 40;13 40;82 7;62 32;58 35;45 21;41 26;44 35;4 50];%30 cities d'=423.741 by D B Fogel
    for i=1:30
        for j=1:30
            DLn(i,j)=((city30(i,1)-city30(j,1))^2+(city30(i,2)-city30(j,2))^2)^0.5;
        end
    end
    cityn=city30;
end
 
if n==50
    city50=[31 32;32 39;40 30;37 69;27 68;37 52;38 46;31 62;30 48;21 47;25 55;16 57;
        17 63;42 41;17 33;25 32;5 64;8 52;12 42;7 38;5 25; 10 77;45 35;42 57;32 22;
        27 23;56 37;52 41;49 49;58 48;57 58;39 10;46 10;59 15;51 21;48 28;52 33;
        58 27;61 33;62 63;20 26;5 6;13 13;21 10;30 15;36 16;62 42;63 69;52 64;43 67];%50 cities d'=427.855 by D B Fogel
    for i=1:50
        for j=1:50
            DLn(i,j)=((city50(i,1)-city50(j,1))^2+(city50(i,2)-city50(j,2))^2)^0.5;
        end
    end
    cityn=city50;
end
 
if n==75
    city75=[48 21;52 26;55 50;50 50;41 46;51 42;55 45;38 33;33 34;45 35;40 37;50 30;
        55 34;54 38;26 13;15 5;21 48;29 39;33 44;15 19;16 19;12 17;50 40;22 53;21 36;
        20 30;26 29;40 20;36 26;62 48;67 41;62 35;65 27;62 24;55 20;35 51;30 50;
        45 42;21 45;36 6;6 25;11 28;26 59;30 60;22 22;27 24;30 20;35 16;54 10;50 15;
        44 13;35 60;40 60;40 66;31 76;47 66;50 70;57 72;55 65;2 38;7 43;9 56;15 56;
        10 70;17 64;55 57;62 57;70 64;64 4;59 5;50 4;60 15;66 14;66 8;43 26];%75 cities d'=549.18 by D B Fogel
    for i=1:75
        for j=1:75
            DLn(i,j)=((city75(i,1)-city75(j,1))^2+(city75(i,2)-city75(j,2))^2)^0.5;
        end
    end
    cityn=city75;
end
end
 
%------------------------------------------------
%��Ӧ�Ⱥ���
function F=CalDist(dislist,s)
 
DistanV=0;
n=size(s,2);
for i=1:(n-1)
    DistanV=DistanV+dislist(s(i),s(i+1));
end
DistanV=DistanV+dislist(s(n),s(1));
F=DistanV;
 
end
 
%------------------------------------------------
%��ͼ
function drawTSP(Clist,BSF,bsf,p,f)
CityNum=size(Clist,1);
for i=1:CityNum-1
    plot([Clist(BSF(i),1),Clist(BSF(i+1),1)],[Clist(BSF(i),2),Clist(BSF(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(BSF(i),1),Clist(BSF(i),2),['  ',int2str(BSF(i))]);
    text(Clist(BSF(i+1),1),Clist(BSF(i+1),2),['  ',int2str(BSF(i+1))]);
    hold on;
end
plot([Clist(BSF(CityNum),1),Clist(BSF(1),1)],[Clist(BSF(CityNum),2),Clist(BSF(1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'����TSP']);
if f==0&&CityNum~=10
    text(5,5,['�� ',int2str(p),' ��','  ��̾���Ϊ ',num2str(bsf)]);
else
    text(5,5,['���������������̾��� ',num2str(bsf),'�� �ڵ� ',num2str(p),' ���ﵽ']);
end
if CityNum==10
    if f==0
        text(0,0,['�� ',int2str(p),' ��','  ��̾���Ϊ ',num2str(bsf)]);
    else
        text(0,0,['���������������̾��� ',num2str(bsf),'�� �ڵ� ',num2str(p),' ���ﵽ']);
    end
end
hold off;
pause(0.05); 
end