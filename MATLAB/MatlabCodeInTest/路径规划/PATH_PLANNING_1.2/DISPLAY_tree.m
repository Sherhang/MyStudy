function DISPLAY_tree(tree,handle)
    %Sort the tree
    sortedTree = sortrows(tree,3);
    
    %Now plot tree
    for i = 2:size(tree,1)
        plot([sortedTree(i,2),tree(sortedTree(i,3),2)],[sortedTree(i,1),tree(sortedTree(i,3),1)],'r');
    end
end