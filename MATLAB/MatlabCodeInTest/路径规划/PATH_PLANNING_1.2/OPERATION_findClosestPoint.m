function pointNumber = OPERATION_findClosestPoint(x,y,arrayOfPoints)
    %Go through each points and find the distances between them and the
    %target point
    distance = inf;
    for i = 1:size(arrayOfPoints,2)
        range = (x-arrayOfPoints(1,i))^2+(y-arrayOfPoints(2,i))^2;
        
        if(range < distance)
            distance = range;
            pointNumber = i;
        end
    end
end