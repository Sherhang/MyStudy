   clear;
   clc;
   num=3;
   t=100;
   E_new=[1 5 2];
   E_current=[2 3 4];
   E_best=[1.5 2 3];
   sol_new=[1 2 3; 1 3 2; 3 1 2];
   sol_current=[2 3 1; 1 3 2; 3 2 1];
   sol_best=[3 2 3; 1 3 2; 3 2 1];


    matrix=(E_new-E_current)<=0;
    E_current=E_new*diag(matrix)+E_current*diag(-matrix+1);
    sol_current =diag(matrix)* sol_new+diag(-matrix+1)*sol_current;
    matrix=(E_new-E_best)<0;
    E_best=E_new*diag(matrix)+E_best*diag(-matrix+1);
    sol_best =diag(matrix)* sol_new+diag(-matrix+1)*sol_best;
    matrix=(rand(1,num)-exp(-(E_new - E_current).*100 ./t))<=0;
    E_current = E_new*diag(matrix)+E_current*diag(-matrix+1);
    sol_current =diag(matrix)* sol_new+diag(-matrix+1)*sol_current;