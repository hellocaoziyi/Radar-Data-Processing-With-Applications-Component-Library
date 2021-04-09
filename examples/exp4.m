clear;
close all;

for monte = 1:50
    
storageName = strcat('exp2_',num2str(monte),'.mat');
load(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp2\',storageName]);

[Xhat1_1E,P1_1E] = extendedKalmanFilter(Zpol1_1,Q,Rpol1,T,origin1);
[Xhat1_2E,P1_2E] = extendedKalmanFilter(Zpol1_2,Q,Rpol2,T,origin2);
[Xhat1_3E,P1_3E] = extendedKalmanFilter(Zpol1_3,Q,Rpol3,T,origin3);

storageName = strcat('exp4_',num2str(monte),'.mat');
save(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp4\',storageName],'X1','Q','k','T',...
    'origin1','origin2','origin3','Rpol1','Rpol2','Rpol3',...
    'Zpol1_1','Zpol1_2','Zpol1_3','Zcart1_1','Zcart1_2','Zcart1_3',...
    'Xhat1_1E','Xhat1_2E','Xhat1_3E','P1_1E','P1_2E','P1_3E');

end

hold on;
plot(X1(1,:),X1(3,:),'k','LineWidth',2,'DisplayName','真实轨迹');
scatter(origin1(1,1),origin1(2,1),'b','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(origin2(1,1),origin2(2,1),'rs','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(origin3(1,1),origin3(2,1),'cd','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Xhat1_1E(1,:),Xhat1_1E(3,:),'b--','LineWidth',2,'DisplayName','雷达1 EKF滤波轨迹');
plot(Xhat1_2E(1,:),Xhat1_2E(3,:),'r-.','LineWidth',2,'DisplayName','雷达2 EKF滤波轨迹');
plot(Xhat1_3E(1,:),Xhat1_3E(3,:),'c:','LineWidth',2,'DisplayName','雷达3 EKF滤波轨迹');
title('运动轨迹和滤波轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();