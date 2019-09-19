function DISPLAY_best_path(Q,winning_nb,handle)
    %Follow from the end to the start
    nb = winning_nb;
    while(nb~=1)
        Y = [Q(nb,1)-1,Q(Q(nb,3),1)-1]+1;
        X = [Q(nb,2)+1,Q(Q(nb,3),2)+1]-1;
        nb = Q(nb,3);
        plot(X,Y,'b');
    end
end