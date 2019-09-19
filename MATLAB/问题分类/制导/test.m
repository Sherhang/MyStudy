%--------------------------------------------------------------------------%
% Predictor Observers for PN Systems Subjected to Seeker Delay             %
% 模型为弹目追逐模型                                                        %                 
% 假设在初始时刻有目标初始状态，寻的导弹发射后完全通过自身探测目标位置制导      %
% xD=F*x(t)+G1*XNT+G*w                                                     %
% 最优导引OPT                                                              %
% 无时间延迟D,无预测器                                                      %
% P代表导弹位置，T代表目标位置        
%PV,TV矩阵每一行，分别是速度大小和方向角
% XNT:目标加速度 XNC:导弹加速度指令 XLAM:弹目视线角                          %
%--------------------------------------------------------------------------%


clc
clear
%预设参数
P=[100,20;
    100,60;
    120,90];
T=[200,500];
PV=[10,30;
    10,60;
    10,10];
TV=[5,0];

% 基本参数设置
i=1;
for k=1:1:3
   
VM =PV(i,1);
VT =TV(1,1);
XNT=0;
XNC=0;
AM=XNC;
XNP=3.;
RM1=P(i,1);
RM2=P(i,2);
RT1=T(1,1);
RT2=T(1,2);
BETA=TV(1,2);
VT1=VT*cos(BETA);
VT2=VT*sin(BETA);
t=0;
RTM1=RT1-RM1;
RTM2=RT2-RM2;
RTM=sqrt(RTM1*RTM1+RTM2*RTM2);
BEMA=PV(i,2)/180*pi;
VM=PV(i,1);
VM1=VM*cos(BEMA);
VM2=VM*sin(BEMA);
VTM1=VT1-VM1;
VTM2=VT2-VM2;
VC=-(RTM1*VTM1+RTM2*VTM2)/RTM;
Time=0;
n=0;
% 主循环

while RTM>10
    h=0.001;
    Time=Time+h;
    BETAOLD=BETA;
    RT1OLD=RT1;
    RT2OLD=RT2;
    RM1OLD=RM1;
    RM2OLD=RM2;
    VM1OLD=VM1;
    VM2OLD=VM2;
    STEP=1;
    FLAG=0;
    while STEP==1
        if FLAG==1
            STEP=2;
            BETA=BETA+h*BETAD;
            RT1=RT1+h*VT1;
            RT2=RT2+h*VT2;
            RM1=RM1+h*VM1;
            RM2=RM2+h*VM2;
            VM1=VM1+h*AM1;
            VM2=VM2+h*AM2;
            t=t+h;
           
        end
        RTM1=RT1-RM1;
        RTM2=RT2-RM2;
        RTM=sqrt(RTM1*RTM1+RTM2*RTM2);
        VTM1=VT1-VM1;
        VTM2=VT2-VM2;
        VC=-(RTM1*VTM1+RTM2*VTM2)/RTM;
        VC1=-VTM1;
        XLAM=atan2(RTM2,RTM1);
        XLAMD=(RTM1*VTM2-RTM2*VTM1)/(RTM*RTM);
        K=[XNP*VC1^2/RTM1^2,XNP*VC1/RTM1,0];%PNG
        XNC=K*[RTM2;VTM2;XNT];
        %         XNC=XNP*VC*XLAMD;
        AM=XNC;
        AM1=-XNC*sin(XLAM);
        AM2=XNC*cos(XLAM);
        VT1=VT*cos(BETA);
        VT2=VT*sin(BETA);
        BETAD=XNT/VT;
        %         AT1=0;
        %         AT2=XNT*cos(w*t);
        FLAG=1;
    end
    FLAG=0;
    BETA=.5*(BETAOLD+BETA+h*BETAD);
    RT1=.5*(RT1OLD+RT1+h*VT1);
    RT2=.5*(RT2OLD+RT2+h*VT2);
    RM1=.5*(RM1OLD+RM1+h*VM1);
    RM2=.5*(RM2OLD+RM2+h*VM2);
    VM1=.5*(VM1OLD+VM1+h*AM1);
    VM2=.5*(VM2OLD+VM2+h*AM2);
    
    n=n+1;
    
    VMC(n)=VM1;
    ArrayT(n)=t;
    ArrayRT1(n)=RT1;
    ArrayRT2(n)=RT2;
    ArrayRM1(n)=RM1;
    ArrayRM2(n)=RM2;
    ArrayVM1(i,n)=VM1;
    ArrayVM2(i,n)=VM2;
    ArrayAM1(n)=AM1;
    ArrayAM2(n)=AM2;
    ArrayXNCG(n)=XNC;
    ArrayRTM(n)=RTM;
end
P_out(i,1)=RM1;
P_out(i,2)=RM2;
A_out(i)=atan(VM2/VM1);
i=i+1;
%画图
figure
plot(ArrayRT1,ArrayRT2,'r','linewidth',1.25)
hold on
plot(ArrayRM1,ArrayRM2,':b','linewidth',1.25)
title('制导过程')
legend('目标','PNG')
xlabel('x方向（m）' )
ylabel('y方向（m）') ;

end



