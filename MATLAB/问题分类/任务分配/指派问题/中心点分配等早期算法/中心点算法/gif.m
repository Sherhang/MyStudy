pic_num = 1;
steps=100;
for k = 1:steps
    figure(1);
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    %******×Ô¼ºµÄplot
    plot();
    hold on;
    plot();
    hold off;
    %*************
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