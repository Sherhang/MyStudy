function DISPLAY_patchwork(map,handle)
    
    HEIGHT = size(map,1);
    WIDTH = size(map,2);
    
    %Preallocate space
    x = zeros(1,HEIGHT*WIDTH);
    y = zeros(1,HEIGHT*WIDTH);
    ex = zeros(4,HEIGHT*WIDTH);
    ey = zeros(4,HEIGHT*WIDTH);
    
    %Build coordinates for nodes
    for i = 1:(WIDTH+1)
        for j = 1:(HEIGHT+1)
            x((HEIGHT+1)*(i-1)+j) = i;
            y((HEIGHT+1)*(i-1)+j) = -j;
        end
    end

    %Associate nodes with elements
    for i = 1:WIDTH
        for j = 1:HEIGHT
            ex(1,HEIGHT*(i-1)+j) = x((HEIGHT+1)*(i-1)+j);
            ex(2,HEIGHT*(i-1)+j) = x((HEIGHT+1)*(i-1)+j+1);
            ex(3,HEIGHT*(i-1)+j) = x((HEIGHT+1)*i+j+1);
            ex(4,HEIGHT*(i-1)+j) = x((HEIGHT+1)*i+j);
            ey(1,HEIGHT*(i-1)+j) = y((HEIGHT+1)*(i-1)+j);
            ey(2,HEIGHT*(i-1)+j) = y((HEIGHT+1)*(i-1)+j+1);
            ey(3,HEIGHT*(i-1)+j) = y((HEIGHT+1)*i+j+1);
            ey(4,HEIGHT*(i-1)+j) = y((HEIGHT+1)*i+j);
        end
    end
    
    %Now display the patches
    for i = 1:WIDTH
        for j = 1:HEIGHT
            if(map(j,i) == 1)
            else
                patch(ex(:,HEIGHT*(i-1)+j),ey(:,HEIGHT*(i-1)+j),'k');
            end
        end
    end
    axis([1,WIDTH+1,-1-HEIGHT,-1]);
end