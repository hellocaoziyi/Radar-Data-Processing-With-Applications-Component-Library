clearvars -except i_exp;
close all;
load('pathname.mat');

load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\exp5_1']);

Xhat_monte = zeros(Target.nIter,Station.nStation);
XEhat_monte = zeros(Target.nIter,Station.nStation);
Xhat_ci_monte = 0;
XEhat_ci_monte = 0;

for iMonte = 1:nMonte
    
    storageName = strcat('exp5_',num2str(iMonte),'.mat');
    load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName]);
    
    for jStation = 1:Station.nStation
        Xhat_monte(:,jStation) = Xhat_monte(:,jStation)' + (Target.X(1,:) - Station.Xhat(1,:,jStation)).^2 + (Target.X(3,:) - Station.Xhat(3,:,jStation)).^2;
        XEhat_monte(:,jStation) = XEhat_monte(:,jStation)' + (Target.X(1,:) - Station.XEhat(1,:,jStation)).^2 + (Target.X(3,:) - Station.XEhat(3,:,jStation)).^2;
    end
    Xhat_ci_monte = Xhat_ci_monte + (Target.X(1,:) - Station.Xhat_ci(1,:)).^2 + (Target.X(3,:) - Station.Xhat_ci(3,:)).^2;
    XEhat_ci_monte = XEhat_ci_monte + (Target.X(1,:) - Station.XEhat_ci(1,:)).^2 + (Target.X(3,:) - Station.XEhat_ci(3,:)).^2;
    
end

for iStation = 1:Station.nStation
    Xhat_monte(:,iStation) = (Xhat_monte(:,iStation)./iMonte).^0.5;
    XEhat_monte(:,iStation) = (XEhat_monte(:,iStation)./iMonte).^0.5;
end
Xhat_ci_monte = (Xhat_ci_monte./nMonte).^0.5;
XEhat_ci_monte = (XEhat_ci_monte./nMonte).^0.5;

Station.Xhat_monte = Xhat_monte;
Station.XEhat_monte = XEhat_monte;
Station.Xhat_ci_monte = Xhat_ci_monte;
Station.XEhat_ci_monte = XEhat_ci_monte;

exp6_1 = figure('Name','exp6_1');
exp6_1.Visible = 'off';
hold on;
plot(Station.Xhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 KF 滤波');
plot(Station.Xhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 KF 滤波');
plot(Station.Xhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 KF 滤波');
plot(Station.Xhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','KF 滤波 CI 融合');
title('Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.emf'],'Resolution',600);
exportgraphics(exp6_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_1.jpg'],'Resolution',600);

exp6_2 = figure('Name','exp6_2');
exp6_2.Visible = 'off';
hold on;
plot(Station.XEhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1 EKF 滤波');
plot(Station.XEhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2 EKF 滤波');
plot(Station.XEhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3 EKF 滤波');
plot(Station.XEhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',2,'DisplayName','EKF 滤波 CI 融合');
title('Extended Kalman 滤波误差分析','FontSize',20);
legend();
xlabel('仿真时间/s','FontSize',20);
ylabel('RMSE/m','FontSize',20);
exportgraphics(exp6_2,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.emf'],'Resolution',600);
exportgraphics(exp6_2,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_2.jpg'],'Resolution',600);

exp6_3 = figure('Name','exp6_3');
exp6_3.Visible = 'off';
hold on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
plot(Station.Zcart(1,:,1),Station.Zcart(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Station.Xhat(1,:,1),Station.Xhat(3,:,1),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达1 KF 滤波轨迹');
plot(Station.Xhat_ci(1,:),Station.Xhat_ci(3,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
scatter(Station.address(1,1),Station.address(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
xlabel('x/m','FontSize',20);
ylabel('y/m','FontSize',20);
legend();
exportgraphics(exp6_3,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.emf'],'Resolution',600);
exportgraphics(exp6_3,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp6_3.jpg'],'Resolution',600);

storageName = strcat('exp6','.mat');
save([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName],...
    'Target','Station','nMonte');
exp6_1.Visible = 'on';
exp6_2.Visible = 'on';
exp6_3.Visible = 'on';