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
                    for a6=1:8
                        r(6)=a6;
                        for a7=1:8
                            r(7)=a7;
                            for a8=1:8
                                r(8)=a8;
                                for a9=1:8
                                    r(9)=a9;
                                    for a10=1:8
                                        r(10)=a10;
                                        for a11=1:8
                                            r(11)=a11;
                                            for a12=1:8
                                                r(12)=a12;
                                                for a13=1:8
                                                    r(13)=a13;
                                                    for a14=1:8
                                                        r(14)=a14;
                                                        for a15=1:8
                                                            r(15)=a15;
                                                            t=targetF(r);
                                                            if t>tmp
                                                                tmp=t
                                                                s=r
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
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
                                                            
                                                            
                                             
        

  
    
   