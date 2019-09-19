function [x,y] = OPERATION_drawSampleFromEllipse(d,startLocation,endLocation)
    endLoop = 0;
    while(endLoop == 0)
        x = rand(1,1);
        y = rand(1,1);
        D = sqrt((startLocation(1)-endLocation(1))^2+(startLocation(2)-endLocation(2))^2);
        theta = atan2(endLocation(2)-startLocation(2),endLocation(1)-startLocation(1));
        x = d*x-0.5*(d-D);
        y = sqrt(d^2-D^2)*y-0.5*sqrt(d^2-D^2);
        vector1 = [cos(theta) -sin(theta);sin(theta) cos(theta)]*[x;y];
        x = vector1(1)+startLocation(1);
        y = vector1(2)+startLocation(2);
        %Does this lie in the ellipse?
        if(sqrt((startLocation(1)-x)^2+(startLocation(2)-y)^2)+sqrt((x-endLocation(1))^2+(y-endLocation(2))^2) < d)
            endLoop = 1;
        end
    end
end