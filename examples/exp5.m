clearvars -except exp_ni;
close all;

for monte = 1:50
    
storageName2 = strcat('exp4_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName2]);

[station.Xhat_ci,station.P_ci] = covarianceIntersection(station.Xhat(:,:,1),station.P(:,:,:,1),1.2,station.Xhat(:,:,2),station.P(:,:,:,2),1,station.Xhat(:,:,3),station.P(:,:,:,3),0.8);
[station.XhatE_ci,station.PE_ci] = covarianceIntersection(station.XhatE(:,:,1),station.PE(:,:,:,1),1.2,station.XhatE(:,:,2),station.PE(:,:,:,2),1,station.XhatE(:,:,3),station.PE(:,:,:,3),0.8);

storageName = strcat('exp5_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName],...
    'target','station');

end