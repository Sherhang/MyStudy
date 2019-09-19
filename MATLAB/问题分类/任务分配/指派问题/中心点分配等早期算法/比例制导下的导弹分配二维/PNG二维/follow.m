clear
clc
N=7; 
%---------------------导弹参数设置-----------------------
V_m=1500*[1 1 1 1 1 1 1]';% 单位：m/s，飞行速度
theta_m=20*pi/180*[1 2 3 4 5 6 7]';%单位：rad，初始弹道倾角

X_m=[0 1 2 3 4 5 6 ]'; %单位：m，位置坐标，X轴
Y_m=[1 2 3 4 5 6 7 ]'; %单位：m，位置坐标，Y轴
 
%---------------------目标参数设置-----------------------
V_t=[300,320,340,320 320 320 320]'; %单位：m/s，目标飞行速度
theta_t=10*pi/180*[1 2 3 4 5 6 7]';%单位：rad，初始弹道偏角

X_t=100+20*[1 2 3 4 5 6 7 ]'; %单位：m，目标位置坐标，X轴
Y_t=200+30*[7 6 5 4 3 2 1]'; %单位：m，目标位置坐标，Y轴

t=0; %单位：s，仿真时刻
dt=0.001;%单位：s，仿真时间步长
n=1;%计数用
R=sqrt((X_m-X_t).^2+(Y_m-Y_t).^2);  % 计算弹目相对距离
dR=-1;

  for i=1:420 %当弹目相对距离增大时，仿真停止\
  for k=1:N
    dX_m=V_m(k)*cos(theta_m(k));
    dY_m=V_m(k)*sin(theta_m(k));
    dX_t=V_t(k)*cos(theta_t(k));
    dY_t=V_t(k)*sin(theta_t(k));
    dR=((X_m(k)-X_t(k))*(dX_m-dX_t)+(Y_m(k)-Y_t(k))*(dY_m-dY_t));
    
    r=sqrt((X_t(k)-X_m(k)).^2+(Y_t(k)-Y_m(k)).^2);  %r为x-y平面内导弹和目标间的距离
    delta_x=X_t(k)-X_m(k);
    delta_y=Y_t(k)-Y_m(k);
    
    theta_m(k)=acos(delta_x./r);  %计算期望会合点的视线角
    
    
    %----------------------------计算拦截弹坐标----------------------------
    X_m(k)=X_m(k)+V_m(k).*delta_x./r*dt;
    Y_m(k)=Y_m(k)+V_m(k).*delta_y./r*dt;
   
    
    %----------------------------计算目标弹坐标----------------------------
    X_t(k)=X_t(k)+V_t(k).*cos(theta_t(k))*dt;
    Y_t(k)=Y_t(k)+V_t(k).*sin(theta_t(k))*dt;
   
    
    X_m_store(k,n)=X_m(k); %保存追踪器坐标
    Y_m_store(k,n)=Y_m(k);
    X_t_store(k,n)=X_t(k); %保存追踪器坐标
    Y_t_store(k,n)=Y_t(k);
   
  end
  n=n+1;
  t=t+dt;
end

figure(1)
plot(X_m_store,Y_m_store,'b*')
hold on
plot(X_t_store,Y_t_store,'ro');
 