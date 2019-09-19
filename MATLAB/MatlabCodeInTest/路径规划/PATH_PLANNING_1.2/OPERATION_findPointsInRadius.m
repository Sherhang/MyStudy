function pointList = OPERATION_findPointsInRadius(x,y,arrayOfPoints,RADIUS)
    counted = 0;
    pointList= [];
    for i = 1:size(arrayOfPoints,1)
        distance = sqrt((arrayOfPoints(i,1)-x)^2+(arrayOfPoints(i,2)-y)^2);
        
        if(distance < RADIUS)
            counted = counted+1;
            pointList(counted,:) = arrayOfPoints(i,:);
        end
    end
end