pic_num = 1;
for k = 1:90
    figure(1);
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
     plot(Tpx(:,k),Tpy(:,k),'or');
     hold on;
     plot(Mpx(:,k),Mpy(:,k),'*b');
     axis(100*[-100 1600 -200 2000]);
     
     hold on;
       
     for j=1:6
        
       if (Msort(j,k)~= Msort(j,k+1)||Tsort(j,k)~= Tsort(j,k+1))
         text(Mpx(j,k),Mpy(j,k)+3000,'C');
%          text(Tpx(j,i),Tpy(j,i)+20,'change');
       end
     end
 
   
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
 text(Tpx(1,k)-10,Tpy(1,k)-10,'Ŀ��1');
     text(Tpx(2,k),Tpy(2,k),'Ŀ��2');
     text(Tpx(3,k),Tpy(3,k),'Ŀ��3');
     text(Tpx(4,k),Tpy(4,k),'Ŀ��4');
     text(Tpx(5,k),Tpy(5,k),'Ŀ��5');
     text(Tpx(6,k),Tpy(6,k),'Ŀ��6');
     text(Tpx(7,k),Tpy(7,k),'Ŀ��7');
     text(Tpx(8,k),Tpy(8,k),'Ŀ��8');
     text(Mpx(1,k),Mpy(1,k),'����1');
     text(Mpx(2,k),Mpy(2,k),'����2');
     text(Mpx(3,k),Mpy(3,k),'����3');
     text(Mpx(4,k),Mpy(4,k),'����4');
     text(Mpx(5,k),Mpy(5,k),'����5');
     text(Mpx(6,k),Mpy(6,k),'����6');
     text(Mpx(7,k),Mpy(7,k),'����7');
     text(Mpx(8,k),Mpy(8,k),'����8');
      text(Mpx(1,1)-5000,Mpy(1,1),'����1');
     text(Mpx(2,1)-5000,Mpy(2,1),'����2');
     text(Mpx(3,1)-5000,Mpy(3,1),'����3');
     text(Mpx(4,1)-5000,Mpy(4,1),'����4');
     text(Mpx(5,1)-5000,Mpy(5,1),'����5');
     text(Mpx(6,1)-5000,Mpy(6,1),'����6');
     text(Mpx(7,1)-5000,Mpy(7,1),'����7');
     text(Mpx(8,1)-5000,Mpy(8,1),'����8');
     hold off;