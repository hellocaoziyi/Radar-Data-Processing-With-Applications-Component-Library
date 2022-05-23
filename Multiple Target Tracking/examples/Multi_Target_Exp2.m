clearvars -except i_exp;
close all;
load('pathname.mat');

storageName = strcat('exp1_',num2str(1),'.mat');
load([pathname,'\Multiple Target Tracking\examples\data\exp1\',storageName],'nMonte');

%产生量测点
%每次使用相同运动轨迹
% storageName = strcat('exp1_',num2str(1),'.mat');
% load([pathname,'\Multiple Target Tracking\examples\data\exp1\',storageName]);

for iMonte = 1:nMonte

%每次使用不同运动轨迹
storageName = strcat('exp1_',num2str(iMonte),'.mat');
load([pathname,'\Multiple Target Tracking\examples\data\exp1\',storageName]);

Station.address = [1400 5300]';
Station.nStation = size(Station.address,2);

Station.Rpol = [0.05^2 0;0 100^2];

Station = polarMeasurement(Target,Station);

storageName = strcat('exp2_',num2str(iMonte),'.mat');
save([pathname,'\examples\data\exp2\',storageName],...
    'Target',...
    'Station',...
    'nMonte');

end

exp2_1 = figure('Name','exp2_1');
exp2_1.Visible = 'off';
hold on;
for targetnum = 1:Target.num
    p(targetnum) = plot(squeeze(Target.X(1,targetnum,:)),squeeze(Target.X(3,targetnum,:)),'Color',defaultPlotColors(targetnum),'LineWidth',2,'DisplayName','目标运动轨迹');
end
p(targetnum+1) = scatter(Station.address(1,1),Station.address(2,1),'MarkerEdgeColor',defaultPlotColors(1),'Marker','o','LineWidth',2,'DisplayName','雷达原点');
for jIter = 1:Target.nIter
        p(Target.num+1+jIter) = scatter(Station.Zcart(1,:,jIter,1),Station.Zcart(2,:,jIter,1),'SizeData',10,'MarkerEdgeColor',defaultPlotColors(mod(jIter,7)),'Marker','o','LineWidth',1,'DisplayName','雷达量测点');
end

title('运动轨迹和量测轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend(p(1:Target.num+2));
exportgraphics(exp2_1,[pathname,'\examples\pic\exp2_1.emf'],'Resolution',600);
exportgraphics(exp2_1,[pathname,'\examples\pic\exp2_1.jpg'],'Resolution',600);
exp2_1.Visible = 'on';