clearvars -except exp_ni;
close all;

for monte = 1:50
    
storageName = strcat('exp3_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp3\',storageName]);

station = extendedKalmanFilter(target,station);

storageName = strcat('exp4_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName],...
    'target','station');

end

exp4_1 = figure('Name','exp4_1');
hold on;
plot(target.X(1,:),target.X(3,:),'Color','#0072BD','LineStyle','-','LineWidth',2,'DisplayName','真实轨迹');
scatter(station.origin(1,1),station.origin(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(station.origin(1,2),station.origin(2,2),'MarkerEdgeColor','#EDB120','Marker','s','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(station.origin(1,3),station.origin(2,3),'MarkerEdgeColor','#7E2F8E','Marker','d','LineWidth',2,'DisplayName','雷达3 量测点');
plot(station.XhatE(1,:,1),station.XhatE(3,:,1),'Color','#D95319','LineStyle','-','LineWidth',2,'DisplayName','雷达1 EKF滤波轨迹');
plot(station.XhatE(1,:,2),station.XhatE(3,:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 EKF滤波轨迹');
plot(station.XhatE(1,:,3),station.XhatE(3,:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 EKF滤波轨迹');
title('运动轨迹和滤波轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();
exportgraphics(exp4_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp4_1.emf','Resolution',600);
exportgraphics(exp4_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp4_1.jpg','Resolution',600);
