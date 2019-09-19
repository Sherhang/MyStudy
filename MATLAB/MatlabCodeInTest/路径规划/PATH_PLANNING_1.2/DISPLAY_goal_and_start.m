function DISPLAY_goal_and_start(START,BOUNDARY,handle)
    plot(handle,START.y,START.x,'r*');
    %Make rectangle for the goal region
    linex = [BOUNDARY.xmin,BOUNDARY.xmin,BOUNDARY.xmax,BOUNDARY.xmax,BOUNDARY.xmin];
    liney = [BOUNDARY.ymin,BOUNDARY.ymax,BOUNDARY.ymax,BOUNDARY.ymin,BOUNDARY.ymin];
    plot(handle,liney,linex,'g--');
end