% This code implements K-means Clustering
% Parameter (K: Number of Clusters, KMI: K-means Iteration)

% Alireza Asvadi
% Department of ECE, SPR Lab
% Babol (Noshirvani) University of Technology
% Questions regarding the code may be directed to:
% http://www.a-asvadi.ir/
% 2013
% Clear Memory & Command Window
clc
clear all
close all
% Generate Points
Sigma = [0.5 0.05; 0.05 0.5];
f1    = mvnrnd([0.5 0]  ,Sigma,100);
f2    = mvnrnd([0.5 0.5],Sigma,100);
f3    = mvnrnd([0.5 1]  ,Sigma,100);
f4    = mvnrnd([0.5 1.5],Sigma,100);
F     = [f1;f2;f3;f4];
% K-means
K     = 4;                                            % Cluster Numbers
KMI   = 40;                                           % K-means Iteration
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
CV    = '+r+b+c+m+k+yorobocomokoysrsbscsmsksy';       % Color Vector

for n = 1:KMI
        
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance CN] = min(DAL(i,1:K));                % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
   
% Plot  
figure(1)
axis([-2 3 -2 3]);
hold on

 for i = 1:K
PT = F(DAL(:,K+1) == i,:);                            % Find points of each cluster    
plot(PT(:,1),PT(:,2),CV(2*i-1:2*i),'LineWidth',2);    % Plot points with determined color and shape
hold on
plot(CENTS(:,1),CENTS(:,2),'k^','LineWidth',2);       % Plot cluster centers


 end



pause(0.1)

end
