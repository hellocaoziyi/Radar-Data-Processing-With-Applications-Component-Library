clearvars -except exp_ni;
close all;

storageName = strcat('exp5_',num2str(1),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName]);

Xhat1_monte = zeros(target.frame,station.num);
Xhat1E_monte = zeros(target.frame,station.num);
Xhat1_ci_monte = 0;
Xhat1_ciE_monte = 0;

for monte = 1:50
    
    storageName = strcat('exp5_',num2str(monte),'.mat');
    load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName]);
    
    for origin_num = 1:station.num
        Xhat1_monte(:,origin_num) = Xhat1_monte(:,origin_num)' + (target.X(1,:) - station.Xhat(1,:,origin_num)).^2 + (target.X(3,:) - station.Xhat(3,:,origin_num)).^2;
        Xhat1E_monte(:,origin_num) = Xhat1E_monte(:,origin_num)' + (target.X(1,:) - station.XhatE(1,:,origin_num)).^2 + (target.X(3,:) - station.XhatE(3,:,origin_num)).^2;
    end
    Xhat1_ci_monte = Xhat1_ci_monte + (target.X(1,:) - station.Xhat_ci(1,:)).^2 + (target.X(3,:) - station.Xhat_ci(3,:)).^2;
    Xhat1_ciE_monte = Xhat1_ciE_monte + (target.X(1,:) - station.XhatE_ci(1,:)).^2 + (target.X(3,:) - station.XhatE_ci(3,:)).^2;
    
end

for origin_num = 1:station.num
    Xhat1_monte(:,origin_num) = (Xhat1_monte(:,origin_num)./monte).^0.5;
    Xhat1E_monte(:,origin_num) = (Xhat1E_monte(:,origin_num)./monte).^0.5;
end
Xhat1_ci_monte = (Xhat1_ci_monte./monte).^0.5;
Xhat1_ciE_monte = (Xhat1_ciE_monte./monte).^0.5;

station.Xhat_monte = Xhat1_monte;
station.XhatE_monte = Xhat1E_monte;
station.Xhat_ci_monte = Xhat1_ci_monte;
station.XhatE_ci_monte = Xhat1_ciE_monte;

exp6_1 = figure('Name','exp6_1');
hold on;
plot(station.Xhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 KF 滤波');
plot(station.Xhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 KF 滤波');
plot(station.Xhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 KF 滤波');
plot(station.Xhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','KF 滤波 CI 融合');
title('Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.emf','Resolution',600);
exportgraphics(exp6_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.jpg','Resolution',600);

exp6_2 = figure('Name','exp6_2');
hold on;
plot(station.XhatE_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 EKF 滤波');
plot(station.XhatE_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 EKF 滤波');
plot(station.XhatE_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 EKF 滤波');
plot(station.XhatE_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','EKF 滤波 CI 融合');
title('Extended Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.emf','Resolution',600);
exportgraphics(exp6_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.jpg','Resolution',600);

exp6_3 = figure('Name','exp6_3');
hold on;
plot(target.X(1,:),target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
plot(station.Zcart(1,:,1),station.Zcart(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(station.Xhat(1,:,1),station.Xhat(3,:,1),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达1 KF 滤波轨迹');
plot(station.Xhat_ci(1,:),station.Xhat_ci(3,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
scatter(station.origin(1,1),station.origin(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
xlabel('x/m','FontSize',20);
ylabel('y/m','FontSize',20);
legend();
exportgraphics(exp6_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.emf','Resolution',600);
exportgraphics(exp6_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.jpg','Resolution',600);

storageName = strcat('exp6','.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName],...
    'target','station');