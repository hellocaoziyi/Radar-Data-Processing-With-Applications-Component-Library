clearvars -except exp_ni;
close all;

for monte = 1:50
    
storageName = strcat('exp1_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName]);

station.origin = [1500 5500;4000 4000;6000 3000]';
station.num = size(station.origin,2);

Rpol1 = [0.04^2 0;0 60^2];
Rpol2 = [0.05^2 0;0 100^2];
Rpol3 = [0.09^2 0;0 150^2];
station.Rpol = cat(3,Rpol1,Rpol2,Rpol3);

station = polarMeasurement(target,station);

storageName = strcat('exp2_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp2\',storageName],...
    'target',...
    'station');

end

exp2_1 = figure('Name','exp2_1');
hold on;
plot(target.X(1,:),target.X(3,:),'Color','#0072BD','LineStyle','-','LineWidth',2,'DisplayName','真实轨迹');
scatter(station.origin(1,1),station.origin(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(station.origin(1,2),station.origin(2,2),'MarkerEdgeColor','#EDB120','Marker','s','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(station.origin(1,3),station.origin(2,3),'MarkerEdgeColor','#7E2F8E','Marker','d','LineWidth',2,'DisplayName','雷达3 量测点');
plot(station.Zcart(1,:,1),station.Zcart(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(station.Zcart(1,:,2),station.Zcart(2,:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2量测轨迹');
plot(station.Zcart(1,:,3),station.Zcart(2,:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3量测轨迹');
title('运动轨迹和量测轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();
exportgraphics(exp2_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_1.emf','Resolution',600);
exportgraphics(exp2_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_1.jpg','Resolution',600);
