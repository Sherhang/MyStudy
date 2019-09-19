%具有碰撞角约束的三维纯比例导引律研究
%无人机空中加油自主会合控制器设计
%说明：在仿真中，下标"_m"表示追踪器参数，下标"_t"表示目标参数
 
clear
clc
 
%---------------------追踪器参数设置-----------------------
V_m=1000; % 单位：m/s，飞行速度
theta_m=45*pi/180;%单位：rad，初始弹道倾角
fea_m=45*pi/180;%单位：rad，初始弹道偏角
X_m=0; %单位：m，位置坐标，X轴
Y_m=0; %单位：m，位置坐标，Y轴
Z_m=0; %单位：m，位置坐标，Z轴
 
%---------------------目标参数设置-----------------------
V_t=300; %单位：m/s，目标飞行速度
theta_t=0*pi/180;%单位：rad，初始弹道偏角
fea_t=0*pi/180;%单位：rad，初始弹道偏角
X_t=1000; %单位：m，目标位置坐标，X轴
Y_t=1000; %单位：m，目标位置坐标，Y轴
Z_t=0; %单位：m，目标位置坐标，Z轴
 
%------------------比例导引律参数设置-----------------------
N1=20; %纵向通道导引系数
N2=20;%偏航通道导引系数
%g=9.8;
 
t=0; %单位：s，仿真时刻
dt=0.001;%单位：s，仿真时间步长
n=1;%计数用
 
R=sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);  % 计算弹目相对距离
dR=-1;
while(dR<0)    %当弹目相对距离增大时，仿真停止
    dX_m=V_m*cos(theta_m)*cos(fea_m);
    dY_m=V_m*sin(theta_m);
    dZ_m=-V_m*cos(theta_m)*sin(fea_m);
    dX_t=V_t*cos(theta_t)*cos(fea_t);
    dY_t=V_t*sin(theta_t);
    dZ_t=-V_t*cos(theta_t)*sin(fea_t);
    dR=((X_m-X_t)*(dX_m-dX_t)+(Y_m-Y_t)*(dY_m-dY_t)+(Z_m-Z_t)*(dZ_m-dZ_t))/sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);
    %-------------------------纵向通道------------------------------
    r1=sqrt((X_t-X_m)^2+(Y_t-Y_m)^2);  %r为x-y平面内导弹和目标间的距离
    delta_x=X_t-X_m;
    delta_y=Y_t-Y_m;
    Ddelta_x=V_t*cos(theta_t)*cos(fea_t)-V_m*cos(theta_m)*cos(fea_m);
    Ddelta_y=V_t*cos(theta_t)-V_m*cos(theta_m);
    Dxl1=(Ddelta_y*delta_x-Ddelta_x*delta_y)/(delta_x^2+delta_y^2);
    theta_l=atan(delta_y/delta_x);  %计算期望会合点的视线角
    Vx_los1=V_m*cos(fea_m)*cos(theta_m-theta_l)-V_t*cos(fea_t)*cos(theta_t-theta_l); 
    Dxd1=(.1*Vx_los1*(theta_t-theta_l))/(N1*r1); 
    
    Dtheta_c=N1*(Dxl1-Dxd1)*dt;  %无人机空中加油自主会合控制器设计-式（1）
    theta_m=theta_m+Dtheta_c;  %计算指令弹道倾角
 
    %-------------------------偏航通道------------------------------
    r2=sqrt((X_t-X_m)^2+(Z_t-Z_m)^2);  %r为x-z平面内两者间的距离
    delta_x=X_t-X_m;
    delta_z=Z_t-Z_m;
    Ddelta_x=V_t*cos(theta_t)*cos(fea_t)-V_m*cos(theta_m)*cos(fea_m);
    Ddelta_z=V_t*cos(theta_t)*sin(fea_t)-V_m*cos(theta_m)*sin(fea_m);
    Dxl=(Ddelta_z*delta_x-Ddelta_x*delta_z)/(delta_x^2+delta_z^2);
    chi_l=-atan(delta_z/delta_x);  %计算期望会合点的视线角
    Vx_los=V_m*cos(theta_m)*cos(fea_m-chi_l)-V_t*cos(theta_t)*cos(fea_t-chi_l); %式（3）
    Dxd=(80*Vx_los*(fea_t-chi_l))/(N2*r2); %式（2）
    
    Dfea_c=N2*(Dxl-Dxd)*dt;  %式（1）
    fea_m=fea_m+Dfea_c;  %计算指令航向角
        
    %----------------------------计算拦截弹坐标----------------------------
    X_m=X_m+V_m*cos(theta_m)*cos(fea_m)*dt;
    Y_m=Y_m+V_m*sin(theta_m)*dt;
    Z_m=Z_m-V_m*cos(theta_m)*sin(fea_m)*dt;
    
    %----------------------------计算目标弹坐标----------------------------
    X_t=X_t+V_t*cos(theta_t)*cos(fea_t)*dt;
    Y_t=Y_t+V_t*sin(theta_t)*dt;
    Z_t=Z_t-V_t*cos(theta_t)*sin(fea_t)*dt;
    
    R=sqrt((X_m-X_t)^2+(Y_m-Y_t)^2+(Z_m-Z_t)^2);%相对距离
    
    %-------------------------保存结果------------------------------
    theta_m_store(n)=theta_m;  %保存弹道倾角
    fea_m_store(n)=fea_m;   %保存弹道偏角   
    P_m_store(:,n)=[X_m;Y_m;Z_m]; %保存追踪器坐标
    P_t_store(:,n)=[X_t;Y_t;Z_t]; %保存目标坐标
    R_store(n)=R;%保存相对距离
    
    n=n+1;  %每循环一次，计数加一
    t=t+dt; %往前推进一个仿真步长
end
disp('脱靶量为（m）：')
R
figure(1)
plot((1:n-1)*dt,theta_m_store*180/pi)
xlabel('time/s')
ylabel('弹道倾角/deg')
title('末制导：弹道倾角变化情况')
figure(2)
plot((1:n-1)*dt,fea_m_store(1,:)*180/pi)
xlabel('time/s')
ylabel('弹道偏角/deg')
title('末制导：弹道偏角变化情况')
figure(3)%注意matlab三维坐标画图X、Y、Z轴方向与导弹飞行力学坐标系不同
plot3(P_m_store(1,:),P_m_store(3,:),P_m_store(2,:),P_t_store(1,:),P_t_store(3,:),P_t_store(2,:))
legend('追踪器运动轨迹','目标运动轨迹')
xlabel('X/m')
ylabel('-Z/m')
zlabel('Y/m')
figure(4)
plot((1:n-1)*dt,R_store)
xlabel('time/s')
ylabel('相对距离/m')
title('相对距离变化情况')
