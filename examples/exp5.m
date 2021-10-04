clearvars -except i_exp;
close all;
load('pathname.mat');

load([pathname,'\examples\data\exp4\exp4_1'],'nMonte');

for iMonte = 1:nMonte
    
storageName2 = strcat('exp4_',num2str(iMonte),'.mat');
load([pathname,'\examples\data\exp4\',storageName2]);

Station = covarianceIntersection(Target,Station);

storageName = strcat('exp5_',num2str(iMonte),'.mat');
save([pathname,'\examples\data\exp5\',storageName],...
    'Target','Station','nMonte');

end