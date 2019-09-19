faiRmax=110;%À×´ïËÑË÷·½Î»½Ç
faiMmax=100;
faiMKmax=30;%
j=1;m=180;n=1;
A=1:180;
for i=1:m
    for j=1:n
        fai=A(i);
        if(fai>=faiMmax&&fai<=faiRmax)
            Fa1(i,j)=0.3*(1-(fai-faiMmax)/(faiRmax-faiMmax));
        end
        if(fai>=faiMKmax&&fai<=faiMmax)
            Fa1(i,j)=0.8-((fai-faiMKmax)/2/(faiMmax-faiMKmax));
        end
        if(fai>=0&&fai<=faiMKmax)
            Fa1(i,j)=1-fai/5/faiMKmax;
        end
        if(fai>faiRmax)
            Fa1(i,j)=0;
        end
    end
end
plot(Fa1(:,1))