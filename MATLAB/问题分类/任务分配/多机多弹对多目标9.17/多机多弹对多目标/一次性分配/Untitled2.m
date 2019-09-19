clear;
clc;
%��ʼ������
DRmax=10000;%�״������������
DMmax=500;%������󹥻�����
Dmin=1;%������С��������
DMKmax=300;%������󲻿�������
DMKmin=100;%��С����������
faiRmax=110;%�״�������λ��
faiMmax=100;
faiMKmax=30;%




m=6;
mNum=[3 2 4 3 2 3];
n=10;nV=diag([1,1,10,1,1,1,1,1,1,5]);
Pm=rand(m,2);Pn=rand(n,2);
Vm=[5  6 4 5 3 4 ];
Vn=[3  2 3 2 2 2 2 2 2 3];
Am=[1 10 20 30 40 50];
An=[20 30 60 40 50 90 10 20 30 50];



%������������
k=1;orderm=[];
for i=1:m
    for j=1:mNum(i)
        orderm(k)=i;
        k=k+1;
    end
end

%Ŀ������
nVo=nV;
nVo(find(nVo>1))=2;
k=1;ordern=[];
for i=1:n
    for j=1:nVo(i,i)
        ordern(k)=i;
        k=k+1;
    end
end
%���ƾ���
%λ��
for i=1:m
    for j=1:n
        D(i,j)=(sqrt((Pm(i,1)-Pn(j,1)).^2+(Pm(i,2)-Pn(j,2)).^2));
    end
end
for i=1:m
    for j=1:n;
        if (D(i,j)>=DRmax||D(i,j)<10)
            Fp(i,j)=0;
        end
        if (D(i,j)>=DMmax&&D(i,j)<DRmax)
            Fp(i,j)=0.5*exp(-(D(i,j)-DMmax)/(DRmax-DMmax));
        end
        if (D(i,j)>=DMKmax&&D(i,j)<DMmax)
            Fp(i,j)=2^(-(D(i,j)-DMKmax)/(DMmax-DMKmax));
        end
        if (D(i,j)>=DMKmin&&D(i,j)<DMKmax)
            Fp(i,j)=1;
        end
        if (D(i,j)>=10&&D(i,j)<DMKmin)
            Fp(i,j)=2^(-(D(i,j)-DMKmin)/(10-DMKmin));
        end
    end
end
           
%�ٶ�
for i=1:m
    for j=1:n
        if (Vm(i)>1.5*Vn(j))
            Fv(i,j)=1;
        end
        if (Vm(i)>=0.6*Vn(j)&&Vm(i)<=1.5*Vn(j))
            Fv(i,j)=-0.5+Vm(i)/Vn(j);
        end
        if (Vm(i)<0.6*Vn(j))
            Fv(i,j)=0.1;
        end
    end
end
%�Ƕȣ���Ϊ��λ�Ǻͽ����
%��λ�����ƺ���FD1
Am=deg2rad(Am);%���ɻ���
An=deg2rad(An);
for i=1:m
    for j=1:n
        a=[cos(Am(i)),sin(Am(i))];
        b=-[Pm(i,1)-Pn(j,1),Pm(i,2)-Pn(j,2)];
        A1(i,j)=rad2deg(acos(dot(a,b)/(norm(a)*norm(b))));%��Է�λ��
    end
end
for i=1:m
    for j=1:n
        a=[cos(An(j)),sin(An(j))];
        b=-[Pm(i,1)-Pn(j,1),Pm(i,2)-Pn(j,2)];
        A2(i,j)=rad2deg(acos(dot(a,b)/(norm(a)*norm(b))));%��Խ����
    end
end
%��λ������
for i=1:m
    for j=1:n
        fai=A1(i,j);
        if(fai>=faiMmax&&fai<=faiRmax)
            Fa1(i,j)=0.3*(1-(fai-faiMmax)/(faiRmax-faiMmax));
        end
        if(fai>=faiMKmax&&fai<=faiMmax)
            Fa1(i,j)=0.8-((fai-faiMKmax)/2/(faiMmax-faiMKmax));
        end
        if(fai>=0&&fai<=faiMKmax)
            Fa1(i,j)=1-fai/5/faiMKmax;
        end
        if(fai>faiRmax)
            Fa1(i,j)=0;
        end
    end
end
%���������
for i=1:m
    for j=1:n
        fai=A2(i,j);
        if(fai<50)
            Fa2(i,j)=fai/50;
        else 
            Fa2(i,j)=1-(fai-50)/130;
        end
    end
end
%�Ƕ�����
Fa=Fa1.*Fa2;
Val=0.4*Fp+0.4*Fv+0.2*Fa;

        
        
        
    

%  
% �������ƾ���
V01=[];
V01=Val(:,ordern);
V01=V01(orderm,:);
%���岹�����ƾ���
[numofm,numofn]=size(V01);
if numofm<numofn
    V02=[];
    V02=V01;
    V02(numofm+1:numofn,:)=zeros(numofn-numofm,numofn);
end
if numofm==numofn
   V02=V01;
end
if numofm>numofn
    V02=[];
    V02=V01;
    V02(:,numofn+1:numofm)=zeros(numofm,numofm-numofn);
end


%Ŀ����ͷ���
nVo=nV;
nVo(find(nVo>1))=2;
k=1;ordern1=[];
for i=1:n
    for j=1:nVo(i,i)
        nV1(k)=j-1;
        k=k+1;
    end
end
[~,p1]=find(nV1>0);
V02(:,p1)=V02(:,p1)*0.000000001;

