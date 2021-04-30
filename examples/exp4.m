clear;
close all;

for monte = 1:50
    
storageName = strcat('exp2_',num2str(monte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp2\',storageName]);

[Xhat1E,P1E,Hjcob] = extendedKalmanFilter(Zpol1,Q,Rpol,T,origin);

storageName = strcat('exp4_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp4\',storageName],'X1','Q','k','T',...
    'origin','Rpol',...
    'Zpol1','Zcart1',...
    'Xhat1E','P1E',...
    'Hjcob');

end

hold on;
plot(X1(1,:),X1(3,:),'k','LineWidth',2,'DisplayName','真实轨迹');
scatter(origin(1,1),origin(2,1),'b','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(origin(1,2),origin(2,2),'rs','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(origin(1,3),origin(2,3),'cd','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Xhat1E(1,:,1),Xhat1E(3,:,1),'b--','LineWidth',2,'DisplayName','雷达1 EKF滤波轨迹');
plot(Xhat1E(1,:,2),Xhat1E(3,:,2),'r-.','LineWidth',2,'DisplayName','雷达2 EKF滤波轨迹');
plot(Xhat1E(1,:,2),Xhat1E(3,:,3),'c:','LineWidth',2,'DisplayName','雷达3 EKF滤波轨迹');
title('运动轨迹和滤波轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();