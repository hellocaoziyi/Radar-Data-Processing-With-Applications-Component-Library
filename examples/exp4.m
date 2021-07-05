clearvars -except i_exp;
close all;
load('pathname.mat');

load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp3\exp3_1'],'nMonte');

for monte = 1:nMonte
    
storageName = strcat('exp3_',num2str(monte),'.mat');
load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp3\',storageName]);

Station = extendedKalmanFilter(Target,Station);

storageName = strcat('exp4_',num2str(monte),'.mat');
save([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName],...
    'Target','Station','nMonte');

end

exp4_1 = figure('Name','exp4_1');
exp4_1.Visible = 'off';
hold on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineStyle','-','LineWidth',2,'DisplayName','真实轨迹');
scatter(Station.address(1,1),Station.address(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(Station.address(1,2),Station.address(2,2),'MarkerEdgeColor','#EDB120','Marker','s','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(Station.address(1,3),Station.address(2,3),'MarkerEdgeColor','#7E2F8E','Marker','d','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Station.XEhat(1,:,1),Station.XEhat(3,:,1),'Color','#D95319','LineStyle','-','LineWidth',2,'DisplayName','雷达1 EKF滤波轨迹');
plot(Station.XEhat(1,:,2),Station.XEhat(3,:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 EKF滤波轨迹');
plot(Station.XEhat(1,:,3),Station.XEhat(3,:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 EKF滤波轨迹');
title('运动轨迹和滤波轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();
exportgraphics(exp4_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp4_1.emf'],'Resolution',600);
exportgraphics(exp4_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp4_1.jpg'],'Resolution',600);
exp4_1.Visible = 'on';