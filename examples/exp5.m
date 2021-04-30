clear;
close all;

for monte = 1:50
    
storageName = strcat('exp3_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp3\',storageName]);
storageName2 = strcat('exp4_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName2],...
    'Xhat1E','P1E','Hjcob');

[Xhat1_ci,P1_ci] = covarianceIntersection(Xhat1(:,:,1),P1(:,:,:,1),1.2,Xhat1(:,:,2),P1(:,:,:,2),1,Xhat1(:,:,3),P1(:,:,:,3),0.8);
[Xhat1_ciE,P1_ciE] = covarianceIntersection(Xhat1E(:,:,1),P1E(:,:,:,1),1.2,Xhat1E(:,:,2),P1(:,:,:,2),1,Xhat1E(:,:,3),P1E(:,:,:,3),0.8);

storageName = strcat('exp5_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName],'X1','Q','k','T',...
    'origin','Rpol',...
    'Zpol1','Zcart1',...
    'Xhat1','P1',...
    'Xhat1E','P1E',...
    'Xhat1_ci','P1_ci','Xhat1_ciE','P1_ciE',...
    'Hjcob');

end