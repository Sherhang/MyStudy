tmp=0;
s=0;
t1=clock;
for a1=1:8
    r(1)=a1;
    for a2=1:8
        r(2)=a2;
        for a3=1:8
            r(3)=a3;
            for a4=1:8
                r(4)=a4;
                for a5=1:8
                    r(5)=a5;
                    t=targetF85(r);
                    if t>tmp
                        tmp=t;
                        s=r;
                    end
                end
            end
        end
    end
end                                                                                           
t2=clock;
time=t2-t1
tmp
s
                                                            
                                                            
                                             
        

  
    
   