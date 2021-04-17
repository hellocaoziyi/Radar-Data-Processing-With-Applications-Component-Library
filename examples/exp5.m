clear;
close all;

for monte = 1:50
    
storageName = strcat('exp3_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp3\',storageName]);
storageName2 = strcat('exp4_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName2],...
    'Xhat1_1E','Xhat1_2E','Xhat1_3E','P1_1E','P1_2E','P1_3E');

[Xhat1_ci,P1_ci] = covarianceIntersection(Xhat1_1,P1_1,1.2,Xhat1_2,P1_2,1,Xhat1_3,P1_3,0.8);
[Xhat1_ciE,P1_ciE] = covarianceIntersection(Xhat1_1E,P1_1E,1.2,Xhat1_2E,P1_2E,1,Xhat1_3E,P1_3E,0.8);

storageName = strcat('exp5_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName],'X1','Q','k','T',...
    'origin1','origin2','origin3','Rpol1','Rpol2','Rpol3',...
    'Zpol1_1','Zpol1_2','Zpol1_3','Zcart1_1','Zcart1_2','Zcart1_3',...
    'Xhat1_1','Xhat1_2','Xhat1_3','P1_1','P1_2','P1_3',...
    'Xhat1_1E','Xhat1_2E','Xhat1_3E','P1_1E','P1_2E','P1_3E',...
    'Xhat1_ci','P1_ci','Xhat1_ciE','P1_ciE');

end