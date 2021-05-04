clearvars -except exp_ni;
close all;

for monte = 1:50
    
storageName2 = strcat('exp4_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName2]);

station = covarianceIntersection(target,station);

storageName = strcat('exp5_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName],...
    'target','station');

end