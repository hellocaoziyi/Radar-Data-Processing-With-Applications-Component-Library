clear;
close all;

for monte = 1:50
    
storageName = strcat('exp1_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName]);

origin = [1500 5500;4000 4000;6000 3000]';

Rpol1 = [0.04^2 0;0 60^2];
Rpol2 = [0.05^2 0;0 100^2];
Rpol3 = [0.09^2 0;0 150^2];
Rpol = cat(3,Rpol1,Rpol2,Rpol3);

[Zpol1,Zcart1] = polarMeasurement(X1,Rpol,origin);

storageName = strcat('exp2_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp2\',storageName],'X1','Q','k','T',...
    'origin','Rpol',...
    'Zpol1','Zcart1');

end

hold on;
plot(X1(1,:),X1(3,:),'Color','#0072BD','LineStyle','-','LineWidth',2,'DisplayName','真实轨迹');
scatter(origin(1,1),origin(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(origin(1,2),origin(2,2),'MarkerEdgeColor','#EDB120','Marker','s','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(origin(1,3),origin(2,3),'MarkerEdgeColor','#7E2F8E','Marker','d','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Zcart1(1,:,1),Zcart1(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Zcart1(1,:,2),Zcart1(2,:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2量测轨迹');
plot(Zcart1(1,:,3),Zcart1(2,:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3量测轨迹');
title('运动轨迹和量测轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();