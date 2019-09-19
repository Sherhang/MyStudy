function [Q,best_goal_point] = RRT(map,START,BOUNDARY,handles)
    
    STARTX = START.x;
    STARTY = START.y;
    
    goalReached = 0;
    goalBoundary = [BOUNDARY.xmax,BOUNDARY.xmin;BOUNDARY.ymin,BOUNDARY.ymax];
    arrayOfPoints = [STARTX;STARTY];
    numberOfPoints = 1;
    Q(1,:) = [STARTX,STARTY,0,1,0];
    
    %RRT
    HEIGHT = size(map,1);
    WIDTH = size(map,2);

    %Open space or obstacle
    DISPLAY_patchwork(map);
    
    while(goalReached == 0)
        %Point generation
        x = -HEIGHT*rand(1,1)-1;
        y = WIDTH*rand(1,1)+1;
        
        %Associate with the closest point
        pointNum = OPERATION_findClosestPoint(x,y,arrayOfPoints);

        %Follow the line to see if it intersects anything
        intersects = OPERATION_doesItIntersect(x,y,arrayOfPoints(:,pointNum),map);

        %If there is no intersection we need to add to the tree
        if(intersects ~= 1)
            arrayOfPoints(:,numberOfPoints+1) = [x;y];
            numberOfPoints = numberOfPoints + 1;

            Q(numberOfPoints,1:2) = [x;y];
            Q(numberOfPoints,3) = pointNum;
            Q(numberOfPoints,4) = numberOfPoints;
            Q(numberOfPoints,5) = Q(pointNum,5)+sqrt((Q(pointNum,1)-x)^2+(Q(pointNum,2)-y)^2);

            %Check to see if this new point is within the goal
            if(x < goalBoundary(1,1) && x > goalBoundary(1,2) && y > goalBoundary(2,1) && y < goalBoundary(2,2))
                goalReached = 1;
            end
        end
        if(rem(numberOfPoints,100) == 0)
            str = strcat(num2str(numberOfPoints),' points processed. Still looking for goal.');
            set(handles.MessagePrompt,'String',str);
        end
    end
    best_goal_point = numberOfPoints;
    set(handles.MessagePrompt,'String','Goal found!');
end