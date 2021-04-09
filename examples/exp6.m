clear;
close all;

Xhat1_1_monte = 0;
Xhat1_2_monte = 0;
Xhat1_3_monte = 0;
Xhat1_1E_monte = 0;
Xhat1_2E_monte = 0;
Xhat1_3E_monte = 0;
Xhat1_ci_monte = 0;
Xhat1_ciE_monte = 0;

for monte = 1:50
    
storageName = strcat('exp5_',num2str(monte),'.mat');
load(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp5\',storageName]);

Xhat1_1_monte = Xhat1_1_monte + (X1 - Xhat1_1).^2;
Xhat1_2_monte = Xhat1_2_monte + (X1 - Xhat1_2).^2;
Xhat1_3_monte = Xhat1_3_monte + (X1 - Xhat1_3).^2;
Xhat1_1E_monte = Xhat1_1E_monte + (X1 - Xhat1_1E).^2;
Xhat1_2E_monte = Xhat1_2E_monte + (X1 - Xhat1_2E).^2;
Xhat1_3E_monte = Xhat1_3E_monte + (X1 - Xhat1_3E).^2;
Xhat1_ci_monte = Xhat1_ci_monte + (X1 - Xhat1_ci).^2;
Xhat1_ciE_monte = Xhat1_ciE_monte + (X1 - Xhat1_ciE).^2;

end

Xhat1_1_monte = (Xhat1_1_monte./monte).^0.5;
Xhat1_2_monte = (Xhat1_2_monte./monte).^0.5;
Xhat1_3_monte = (Xhat1_3_monte./monte).^0.5;
Xhat1_1E_monte = (Xhat1_1E_monte./monte).^0.5;
Xhat1_2E_monte = (Xhat1_2E_monte./monte).^0.5;
Xhat1_3E_monte = (Xhat1_3E_monte./monte).^0.5;
Xhat1_ci_monte = (Xhat1_ci_monte./monte).^0.5;
Xhat1_ciE_monte = (Xhat1_ciE_monte./monte).^0.5;

hold on;
plot(Xhat1_1_monte(1,:),'LineWidth',2,'DisplayName','雷达1 KF');
plot(Xhat1_2_monte(1,:),'--','LineWidth',2,'DisplayName','雷达2 KF');
plot(Xhat1_3_monte(1,:),'-.','LineWidth',2,'DisplayName','雷达3 KF');
plot(Xhat1_ci_monte(1,:),':','LineWidth',2,'DisplayName','KF CI');
title('Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
figure();
hold on;
plot(Xhat1_1E_monte(1,:),'LineWidth',2,'DisplayName','雷达1 EKF');
plot(Xhat1_2E_monte(1,:),'--','LineWidth',2,'DisplayName','雷达2 EKF');
plot(Xhat1_3E_monte(1,:),'-.','LineWidth',2,'DisplayName','雷达3 EKF');
plot(Xhat1_ciE_monte(1,:),':','LineWidth',2,'DisplayName','EKF CI');
title('Extended Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
figure();
hold on;
plot(X1(1,:),X1(3,:),'LineWidth',2,'DisplayName','真实运动轨迹');
plot(Zcart1_1(1,:),Zcart1_1(2,:),':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Xhat1_1(1,:),Xhat1_1(3,:),'-.','LineWidth',2,'DisplayName','雷达1 KF滤波轨迹');
plot(Xhat1_1E(1,:),Xhat1_1E(3,:),'--','LineWidth',2,'DisplayName','雷达1 EKF滤波轨迹');
scatter(origin1(1,1),origin1(2,1),'LineWidth',2,'DisplayName','雷达1 测量点');
title('量测轨迹和滤波轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);
legend();
storageName = strcat('exp6','.mat');
save(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp6\',storageName],...
    'Xhat1_1_monte','Xhat1_2_monte','Xhat1_3_monte',...
    'Xhat1_1E_monte','Xhat1_2E_monte','Xhat1_3E_monte',...
    'Xhat1_ci_monte','Xhat1_ciE_monte');