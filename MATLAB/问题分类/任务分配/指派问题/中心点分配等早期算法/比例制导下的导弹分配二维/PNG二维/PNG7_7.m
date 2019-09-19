
















































X_m=[0 1 2 3 4 5 6 ]'; %��λ��m��λ�����꣬X��
Y_m=[1 2 3 4 5 6 7 ]'; %��λ��m��λ�����꣬Y��
 
%---------------------Ŀ���������-----------------------
V_t=[300,320,340,320 320 320 320]'; %��λ��m/s��Ŀ������ٶ�
theta_t=20*pi/180*[1 2 3 4 5 6 7]';%��λ��rad����ʼ����ƫ��

X_t=20*[1 2 3 4 5 6 7 ]'; %��λ��m��Ŀ��λ�����꣬X��
Y_t=30*[7 6 5 4 3 2 1]'; %��λ��m��Ŀ��λ�����꣬Y��

 
t=0; %��λ��s������ʱ��
dt=0.001;%��λ��s������ʱ�䲽��
n=1;%������
R=sqrt((X_m-X_t).^2+(Y_m-Y_t).^2);  % ���㵯Ŀ��Ծ���
dR=-1;

  for i=1:500 %����Ŀ��Ծ�������ʱ������ֹͣ\
  for k=1:N
    dX_m=V_m(k)*cos(theta_m(k));
    dY_m=V_m(k)*sin(theta_m(k));
    dX_t=V_t(k)*cos(theta_t(k));
    dY_t=V_t(k)*sin(theta_t(k));
    dR=((X_m(k)-X_t(k))*(dX_m-dX_t)+(Y_m(k)-Y_t(k))*(dY_m-dY_t));
    
    r=sqrt((X_t(k)-X_m(k)).^2+(Y_t(k)-Y_t(k)).^2);  %rΪx-yƽ���ڵ�����Ŀ���ľ���
    delta_x=X_t(k)-X_m(k);
    delta_y=Y_t(k)-Y_m(k);
    theta_q(k)=atan(delta_y./delta_x);  %����������ϵ�����߽�
    dq=((X_t(k)-X_m(k))*(V_t(k)*sin(theta_t(k))-V_m(k)*sin(theta_m(k)))-(Y_t(k)-Y_m(k))*(V_t(k)*cos(theta_t(k))-V_m(k)*cos(theta_m(k))))/((X_m(k)-X_t(k))^2+(Y_m(k)-Y_t(k))^2);
    theta_m(k)=theta_m(k)+dq;
    
    %----------------------------�������ص�����----------------------------
    X_m(k)=X_m(k)+V_m(k).*cos(theta_m(k))*dt;
    Y_m(k)=Y_m(k)+V_m(k).*sin(theta_m(k))*dt;
   
    
    %----------------------------����Ŀ�굯����----------------------------
    X_t(k)=X_t(k)+V_t(k).*cos(theta_t(k))*dt;
    Y_t(k)=Y_t(k)+V_t(k).*sin(theta_t(k))*dt;
   
    
    X_m_store(k,n)=X_m(k); %����׷��������
    Y_m_store(k,n)=Y_m(k);
    X_t_store(k,n)=X_t(k); %����׷��������
    Y_t_store(k,n)=Y_t(k);
   
  end
  n=n+1;
  t=t+dt;
end

figure(1)
plot(X_m_store,Y_m_store,'r*')
hold on
plot(X_t_store,Y_t_store,'bo');
 