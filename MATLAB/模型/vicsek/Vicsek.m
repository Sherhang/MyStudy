%birds a la vicsek et al PRL 1995 
%coded up by Sandra Chapman 
% not designed to be efficient or fast! 
clear all 
close all 
lbox=50. 
%vs=0.03; 
vs=0.5; 
dt=1.; 
%interaction radius 
r=100; 
%r=0.2; 
mindex=0; 
%random fluctuation in angle per step (rads) 
%order 
eta=(2.*pi).*.005 
% near critical 
% 
%eta=(2.*pi).*.3 
%disorder 
%eta=20 
nbird=10; 
birdl=[1:nbird]; 
onebd=ones(1,nbird)'; 
%bird arrays position and angle 
figure 
axis([0 lbox 0 lbox]) 
axis('square') 
hold on 
 
%IC random 
 
xb=rand(nbird,1).*lbox; 
yb=rand(nbird,1).*lbox; 
 
ang=pi.*2.*rand(nbird,1); 
 
vxb=vs.*cos(ang); 
vyb=vs.*sin(ang); 
 
%outer loop 
 
for nsteps=1:10000; 
    nsteps 
    
     
xb=xb+vxb.*dt; 
yb=yb+vyb.*dt; 
 
for bird1=1:nbird; 
%periodic 
if(xb(bird1)<0);xb(bird1)=xb(bird1)+lbox; end 
if (yb(bird1)<0);yb(bird1)=yb(bird1)+lbox;end 
if (xb(bird1)>lbox);xb(bird1)=xb(bird1)-lbox;end 
if (yb(bird1)>lbox);yb(bird1)=yb(bird1)-lbox;end 
 
%find mean angle of neigbours (include bird1) 
 
    sep(1:nbird)=(onebd.*xb(bird1)-xb(1:nbird)).^2+... 
        (onebd.*yb(bird1)-yb(1:nbird)).^2; 
    
    nearang=ang(sep<r); 
    mang(bird1)=mean(nearang); 
end 
    ang=mang'+eta.*(rand(nbird,1)-0.5)*0.01; 
     
vxb=vs.*cos(ang); 
vyb=vs.*sin(ang); 
 
% teh order parameter 
 
%vtot(nsteps)=abs(mean(vxb).^2+mean(vyb).^2); 
%dist(nsteps)=mean(sep); 
 
%plot 
cla 
 
set(gcf,'doublebuffer','on') 
 
plot(xb,yb,'b.') 
%quiver(xb,yb,vxb,vyb,'b') 
 
drawnow 
 
     
end 