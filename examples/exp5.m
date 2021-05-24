clearvars -except i_exp;
close all;

load('C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\exp4_1','nMonte');

for iMonte = 1:nMonte
    
storageName2 = strcat('exp4_',num2str(iMonte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName2]);

Station = covarianceIntersection(Target,Station);

storageName = strcat('exp5_',num2str(iMonte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName],...
    'Target','Station','nMonte');

end