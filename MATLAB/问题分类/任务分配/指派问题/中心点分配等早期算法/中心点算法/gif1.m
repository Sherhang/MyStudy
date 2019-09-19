pic_num = 1;
for k = 1:90
    figure(1);
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    plot(Tpx(:,k),Tpy(:,k),'or');
    hold on;
    plot(Mpx(:,k),Mpy(:,k),'*b');
    axis(100*[-100 1600 -200 2000]);
    text(Tpx(1,k)-10,Tpy(1,k)-10,'目标1');
     text(Tpx(2,k),Tpy(2,k),'目标2');
     text(Tpx(3,k),Tpy(3,k),'目标3');
     text(Tpx(4,k),Tpy(4,k),'目标4');
     text(Tpx(5,k),Tpy(5,k),'目标5');
     text(Tpx(6,k),Tpy(6,k),'目标6');
     text(Tpx(7,k),Tpy(7,k),'目标7');
     text(Tpx(8,k),Tpy(8,k),'目标8');
     text(Mpx(1,k),Mpy(1,k),'导弹1');
     text(Mpx(2,k),Mpy(2,k),'导弹2');
     text(Mpx(3,k),Mpy(3,k),'导弹3');
     text(Mpx(4,k),Mpy(4,k),'导弹4');
     text(Mpx(5,k),Mpy(5,k),'导弹5');
     text(Mpx(6,k),Mpy(6,k),'导弹6');
     text(Mpx(7,k),Mpy(7,k),'导弹7');
     text(Mpx(8,k),Mpy(8,k),'导弹8');
     hold off;
    drawnow;
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    if pic_num == 1
        imwrite(I,map,'test.gif','gif', 'Loopcount',inf,'DelayTime',0);
    else
        imwrite(I,map,'test.gif','gif','WriteMode','append','DelayTime',0);
    end
    pic_num = pic_num + 1;
end