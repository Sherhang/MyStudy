%������ײ��Լ������ά�������������о�
%���˻����м���������Ͽ��������
%˵�����ڷ����У��±�"_m"��ʾ׷�����������±�"_t"��ʾĿ�����
 
clear
clc
 
%---------------------׷������������-----------------------
V_m=1000; % ��λ��m/s�������ٶ�
theta_m=45*pi/180;%��λ��rad����ʼ�������
fea_m=45*pi/180;%��λ��rad����ʼ����ƫ��
X_m=0; %��λ��m��λ�����꣬X��
Y_m=0; %��λ��m��λ�����꣬Y��
Z_m=0; %��λ��m��λ�����꣬Z��
 
%---------------------Ŀ���������-----------------------
V_t=300; %��λ��m/s��Ŀ������ٶ�
theta_t=0*pi/180;%��λ��rad����ʼ����ƫ��
fea_t=0*pi/180;%��λ��rad����ʼ����ƫ��
X_t=1000; %��λ��m��Ŀ��λ�����꣬X��
Y_t=1000; %��λ��m��Ŀ��λ�����꣬Y��
Z_t=0; %��λ��m��Ŀ��λ�����꣬Z��
 
%------------------���������ɲ�������-----------------------
N1=20; %����ͨ������ϵ��
N2=20;%ƫ��ͨ������ϵ��
%g=9.8;
 
t=0; %��λ��s������ʱ��
dt=0.001;%��λ��s������ʱ�䲽��
n=1;%������
 
R=sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);  % ���㵯Ŀ��Ծ���
dR=-1;
while(dR<0)    %����Ŀ��Ծ�������ʱ������ֹͣ
    dX_m=V_m*cos(theta_m)*cos(fea_m);
    dY_m=V_m*sin(theta_m);
    dZ_m=-V_m*cos(theta_m)*sin(fea_m);
    dX_t=V_t*cos(theta_t)*cos(fea_t);
    dY_t=V_t*sin(theta_t);
    dZ_t=-V_t*cos(theta_t)*sin(fea_t);
    dR=((X_m-X_t)*(dX_m-dX_t)+(Y_m-Y_t)*(dY_m-dY_t)+(Z_m-Z_t)*(dZ_m-dZ_t))/sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);
    %-------------------------����ͨ��------------------------------
    r1=sqrt((X_t-X_m)^2+(Y_t-Y_m)^2);  %rΪx-yƽ���ڵ�����Ŀ���ľ���
    delta_x=X_t-X_m;
    delta_y=Y_t-Y_m;
    Ddelta_x=V_t*cos(theta_t)*cos(fea_t)-V_m*cos(theta_m)*cos(fea_m);
    Ddelta_y=V_t*cos(theta_t)-V_m*cos(theta_m);
    Dxl1=(Ddelta_y*delta_x-Ddelta_x*delta_y)/(delta_x^2+delta_y^2);
    theta_l=atan(delta_y/delta_x);  %����������ϵ�����߽�
    Vx_los1=V_m*cos(fea_m)*cos(theta_m-theta_l)-V_t*cos(fea_t)*cos(theta_t-theta_l); 
    Dxd1=(.1*Vx_los1*(theta_t-theta_l))/(N1*r1); 
    
    Dtheta_c=N1*(Dxl1-Dxd1)*dt;  %���˻����м���������Ͽ��������-ʽ��1��
    theta_m=theta_m+Dtheta_c;  %����ָ������
 
    %-------------------------ƫ��ͨ��------------------------------
    r2=sqrt((X_t-X_m)^2+(Z_t-Z_m)^2);  %rΪx-zƽ�������߼�ľ���
    delta_x=X_t-X_m;
    delta_z=Z_t-Z_m;
    Ddelta_x=V_t*cos(theta_t)*cos(fea_t)-V_m*cos(theta_m)*cos(fea_m);
    Ddelta_z=V_t*cos(theta_t)*sin(fea_t)-V_m*cos(theta_m)*sin(fea_m);
    Dxl=(Ddelta_z*delta_x-Ddelta_x*delta_z)/(delta_x^2+delta_z^2);
    chi_l=-atan(delta_z/delta_x);  %����������ϵ�����߽�
    Vx_los=V_m*cos(theta_m)*cos(fea_m-chi_l)-V_t*cos(theta_t)*cos(fea_t-chi_l); %ʽ��3��
    Dxd=(80*Vx_los*(fea_t-chi_l))/(N2*r2); %ʽ��2��
    
    Dfea_c=N2*(Dxl-Dxd)*dt;  %ʽ��1��
    fea_m=fea_m+Dfea_c;  %����ָ����
        
    %----------------------------�������ص�����----------------------------
    X_m=X_m+V_m*cos(theta_m)*cos(fea_m)*dt;
    Y_m=Y_m+V_m*sin(theta_m)*dt;
    Z_m=Z_m-V_m*cos(theta_m)*sin(fea_m)*dt;
    
    %----------------------------����Ŀ�굯����----------------------------
    X_t=X_t+V_t*cos(theta_t)*cos(fea_t)*dt;
    Y_t=Y_t+V_t*sin(theta_t)*dt;
    Z_t=Z_t-V_t*cos(theta_t)*sin(fea_t)*dt;
    
    R=sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);%��Ծ���
    
    %-------------------------������------------------------------
    theta_m_store(n)=theta_m;  %���浯�����
    fea_m_store(n)=fea_m;   %���浯��ƫ��   
    P_m_store(:,n)=[X_m;Y_m;Z_m]; %����׷��������
    P_t_store(:,n)=[X_t;Y_t;Z_t]; %����Ŀ������
    R_store(n)=R;%������Ծ���
    
    n=n+1;  %ÿѭ��һ�Σ�������һ
    t=t+dt; %��ǰ�ƽ�һ�����沽��
end
disp('�Ѱ���Ϊ��m����')
R
figure(1)
plot((1:n-1)*dt,theta_m_store*180/pi)
xlabel('time/s')
ylabel('�������/deg')
title('ĩ�Ƶ���������Ǳ仯���')
figure(2)
plot((1:n-1)*dt,fea_m_store(1,:)*180/pi)
xlabel('time/s')
ylabel('����ƫ��/deg')
title('ĩ�Ƶ�������ƫ�Ǳ仯���')
figure(3)%ע��matlab��ά���껭ͼX��Y��Z�᷽���뵼��������ѧ����ϵ��ͬ
plot3(P_m_store(1,:),P_m_store(3,:),P_m_store(2,:),P_t_store(1,:),P_t_store(3,:),P_t_store(2,:))
legend('׷�����˶��켣','Ŀ���˶��켣')
xlabel('X/m')
ylabel('-Z/m')
zlabel('Y/m')
figure(4)
plot((1:n-1)*dt,R_store)
xlabel('time/s')
ylabel('��Ծ���/m')
title('��Ծ���仯���')
