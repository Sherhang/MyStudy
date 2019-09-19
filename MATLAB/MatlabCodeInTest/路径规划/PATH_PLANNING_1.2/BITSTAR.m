function [Q,best_pos] = BITSTAR(map,START,BOUNDARY,handles)
    %RRT_STAR
    STARTX = START.x;
    STARTY = START.y;
    
    HEIGHT = size(map,1);
    WIDTH = size(map,2);
    RADIUS = 2;
    EXTRA_POINTS = 100;

    goalBoundary = [BOUNDARY.xmax,BOUNDARY.xmin;BOUNDARY.ymin,BOUNDARY.ymax];
    arrayOfPoints = [STARTX;STARTY];
    numberOfPoints = 1;
    Q(1,:) = [STARTX,STARTY,0,1,0];

    %Open space or obstacle
    DISPLAY_patchwork(map);
    
    goalReached = 0;
    while(goalReached == 0)
        %Point generation
        x = -HEIGHT*rand(1,1)-1;
        y = WIDTH*rand(1,1)+1;
        
        pointList = OPERATION_findPointsInRadius(x,y,Q,RADIUS);
        
        %Find connection that provides the least cost to come
        nbCount = 0;
        minCounted = inf;
        minCounter = 0;
        
        if(size(pointList,2)~=0)
            for i = 1:size(pointList,1)
                pointNumber = pointList(i,:);

                %Follow the line to see if it intersects anything
                intersects = OPERATION_doesItIntersect(x,y,transpose(pointNumber(1:2)),map);

                %If there is no intersection we need consider its connection
                nbCount = nbCount + 1;
                if(intersects ~= 1)
                    distance = sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2)+Q(pointNumber(4),5);

                    if(distance < minCounted)
                        minCounted = distance;
                        minCounter = nbCount;
                    end
                end
            end
            if(minCounter > 0)
                arrayOfPoints(:,numberOfPoints+1) = [x;y];
                numberOfPoints = numberOfPoints + 1;

                Q(numberOfPoints,1:2) = [x;y];
                Q(numberOfPoints,3) = pointList(minCounter,4);
                Q(numberOfPoints,4) = numberOfPoints;
                Q(numberOfPoints,5) = minCounted;

                %Now check to see if any of the other points can be redirected
                nbCount = 0;
                for i = 1:size(pointList,1)
                    pointNumber = pointList(i,:);

                    %Follow the line to see if it intersects anything
                    intersects = OPERATION_doesItIntersect(x,y,transpose(pointNumber(1:2)),map);

                    %If there is no intersection we need consider its connection
                    nbCount = nbCount + 1;
                    if(intersects ~= 1)
                        %If the alternative path is shorter than change it
                        if(Q(numberOfPoints,5)+sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2) < Q(pointNumber(4),5))
                            Q(pointNumber(4),3) = numberOfPoints;
                            Q(pointNumber(4),5) = Q(numberOfPoints,5)+sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2);
                        end
                    end
                end

                %Check to see if this new point is within the goal
                if(x < goalBoundary(1,1) && x > goalBoundary(1,2) && y > goalBoundary(2,1) && y < goalBoundary(2,2))
                    goalReached = 1;
                end
            end
        else
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
        end
        if(rem(numberOfPoints,100) == 0)
            str = strcat(num2str(numberOfPoints),' points processed. Still looking for goal.');
            set(handles.MessagePrompt,'String',str);
        end
    end
    best_pos = numberOfPoints;
    set(handles.MessagePrompt,'String','Goal found! Now processing additional points for refinement');
    pathDistance = Q(numberOfPoints,5);
    goal = Q(numberOfPoints,1:2);
    
    %Now the goal has been reached so we must try to improve the path
    for k = 1:EXTRA_POINTS
        %Point generation
        [x,y] = OPERATION_drawSampleFromEllipse(pathDistance,[STARTX,STARTY],goal);
        
        pointList = OPERATION_findPointsInRadius(x,y,Q,RADIUS);
        
        %Find connection that provides the least cost to come
        nbCount = 0;
        minCounted = inf;
        minCounter = 0;
        
        if(size(pointList,2)~=0)
            for i = 1:size(pointList,1)
                pointNumber = pointList(i,:);

                %Follow the line to see if it intersects anything
                intersects = OPERATION_doesItIntersect(x,y,transpose(pointNumber(1:2)),map);

                %If there is no intersection we need consider its connection
                nbCount = nbCount + 1;
                if(intersects ~= 1)
                    distance = sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2)+Q(pointNumber(4),5);

                    if(distance < minCounted)
                        minCounted = distance;
                        minCounter = nbCount;
                    end
                end
            end
            if(minCounter > 0)
                arrayOfPoints(:,numberOfPoints+1) = [x;y];
                numberOfPoints = numberOfPoints + 1;

                Q(numberOfPoints,1:2) = [x;y];
                Q(numberOfPoints,3) = pointList(minCounter,4);
                Q(numberOfPoints,4) = numberOfPoints;
                Q(numberOfPoints,5) = minCounted;

                %Now check to see if any of the other points can be redirected
                nbCount = 0;
                for i = 1:size(pointList,1)
                    pointNumber = pointList(i,:);

                    %Follow the line to see if it intersects anything
                    intersects = OPERATION_doesItIntersect(x,y,transpose(pointNumber(1:2)),map);

                    %If there is no intersection we need consider its connection
                    nbCount = nbCount + 1;
                    if(intersects ~= 1)
                        %If the alternative path is shorter than change it
                        if(Q(numberOfPoints,5)+sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2) < Q(pointNumber(4),5))
                            Q(pointNumber(4),3) = numberOfPoints;
                            Q(pointNumber(4),5) = Q(numberOfPoints,5)+sqrt((pointNumber(1)-x)^2+(pointNumber(2)-y)^2);
                        end
                    end
                end
            end
        else
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
            end
        end
        if(rem(k,100) == 0)
            str = strcat(num2str(k/EXTRA_POINTS),'% of extra points processed.');
            set(handles.MessagePrompt,'String',str);
        end
    end
    set(handles.MessagePrompt,'String','Done!');
end