function block = OPERATION_doesItIntersect(x,y,vector,map)
    x = -x;
    vector(1) = -vector(1);
    distance = sqrt((x-vector(1))^2+(y-vector(2))^2);
    vec = 1/distance*([x;y]-vector);
    range = linspace(0,distance,distance*100);
    block = 0;
    i = 1;
    plot(y,-x,'b*');
    while(block == 0 && i < distance*100)
        position = [x;y]-range(i)*vec;
        
        %Find what block we're in right now
        xi = floor(position(1));
        yi = floor(position(2));
        
        if(xi < size(map,1)+1 && yi < size(map,2)+1 && xi > 0 && yi > 0)
            if(map(xi,yi) == 0)
                block = 1;
            end
        else
            block = 1;
        end
        
        i = i + 1;
    end
end
