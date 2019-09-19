
clear;
clc;

flag1=0;
for time=1:1
    main;
    E(time)=E_best;
    if E_best<550  
        flag1=flag1+1;
    end
end
plot(E);
per=flag1/10