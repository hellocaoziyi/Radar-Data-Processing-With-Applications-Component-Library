clearvars -except exp_ni;
close all;

storageName = strcat('exp5_',num2str(1),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName]);

Xhat1_monte = zeros(size(Zpol1,2),size(Xhat1,3));
Xhat1E_monte = zeros(size(Zpol1,2),size(Xhat1,3));
Xhat1_ci_monte = 0;
Xhat1_ciE_monte = 0;

for monte = 1:50
    
    storageName = strcat('exp5_',num2str(monte),'.mat');
    load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName]);
    
    for origin_num = 1:size(Xhat1,3)
        temp = (X1(1,:) - Xhat1(1,:,origin_num)).^2 + (X1(3,:) - Xhat1(3,:,origin_num)).^2;
        Xhat1_monte(:,origin_num) = Xhat1_monte(:,origin_num)' + (X1(1,:) - Xhat1(1,:,origin_num)).^2 + (X1(3,:) - Xhat1(3,:,origin_num)).^2;
        Xhat1E_monte(:,origin_num) = Xhat1E_monte(:,origin_num)' + (X1(1,:) - Xhat1E(1,:,origin_num)).^2 + (X1(3,:) - Xhat1E(3,:,origin_num)).^2;
    end
    Xhat1_ci_monte = Xhat1_ci_monte + (X1(1,:) - Xhat1_ci(1,:)).^2 + (X1(3,:) - Xhat1_ci(3,:)).^2;
    Xhat1_ciE_monte = Xhat1_ciE_monte + (X1(1,:) - Xhat1_ciE(1,:)).^2 + (X1(3,:) - Xhat1_ciE(3,:)).^2;
    
end

for origin_num = 1:size(Xhat1,3)
    Xhat1_monte(:,origin_num) = (Xhat1_monte(:,origin_num)./monte).^0.5;
    Xhat1E_monte(:,origin_num) = (Xhat1E_monte(:,origin_num)./monte).^0.5;
end
Xhat1_ci_monte = (Xhat1_ci_monte./monte).^0.5;
Xhat1_ciE_monte = (Xhat1_ciE_monte./monte).^0.5;

exp6_1 = figure('Name','exp6_1');
hold on;
plot(Xhat1_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 KF 滤波');
plot(Xhat1_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 KF 滤波');
plot(Xhat1_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 KF 滤波');
plot(Xhat1_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','KF 滤波 CI 融合');
title('Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.emf','Resolution',600);
exportgraphics(exp6_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.jpg','Resolution',600);

exp6_2 = figure('Name','exp6_2');
hold on;
plot(Xhat1E_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 EKF 滤波');
plot(Xhat1E_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 EKF 滤波');
plot(Xhat1E_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 EKF 滤波');
plot(Xhat1_ciE_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','EKF 滤波 CI 融合');
title('Extended Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.emf','Resolution',600);
exportgraphics(exp6_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.jpg','Resolution',600);

exp6_3 = figure('Name','exp6_3');
hold on;
plot(X1(1,:),X1(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
plot(Zcart1(1,:,1),Zcart1(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Xhat1(1,:,1),Xhat1(3,:,1),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达1 KF 滤波轨迹');
plot(Xhat1_ci(1,:),Xhat1_ci(3,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
scatter(origin(1,1),origin(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
xlabel('x/m','FontSize',20);
ylabel('y/m','FontSize',20);
legend();
exportgraphics(exp6_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.emf','Resolution',600);
exportgraphics(exp6_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.jpg','Resolution',600);

storageName = strcat('exp6','.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName],...
    'Xhat1_monte',...
    'Xhat1E_monte',...
    'Xhat1_ci_monte','Xhat1_ciE_monte');