% A=EQplan_store(:,:,7);
% AA=val_store(:,:,7);
% B(1,:)=[0 0];
% r=1;
% for i=1:100
%     for j=1:100
%         if abs(A(i,j))<0.0000001
%             A(i,j)=0;
%         end
%         
%         if 1-A(i,j)<0.00000001
%             A(i,j)=1;
%         end
%         
%         if (A(i,j)>0.00000001&&A(i,j)<0.999999999)
%             B(r,:)=[i j];
%             r=r+1;
%         end 
%     end
% end
N=1000;
a=rand(N,N) ;
minAssign(a)