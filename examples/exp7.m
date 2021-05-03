clearvars -except exp_ni;
close all;
storageName2 = strcat('exp6','.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName2]);

H = [1 0 0 0; 0 0 1 0];
F = [1 target.dt 0 0
    0  1 0 0
    0 0 1 target.dt
    0 0 0 1];
J = zeros(4,4,target.frame);
Jz = zeros(4,4,target.frame);
J(:,:,1) = eye(4);

PCRB1 = posteriorCramerRaoLowerBound(target.Q,target.dt,station.Rpol,H,station.Zcart,station.origin,station.P,"KF");

for ni = 2:target.frame
    A1_1 = [cos(station.Zpol(1,ni,1)) -1*station.Zpol(2,ni,1)*sin(station.Zpol(1,ni,1));...
        sin(station.Zpol(1,ni,1)) station.Zpol(2,ni,1)*cos(station.Zpol(1,ni,1))];
    R1_1(:,:,ni) = A1_1*[station.Rpol(2,2,1) 0;0 station.Rpol(1,1,1)]*A1_1';
    A1_2 = [cos(station.Zpol(1,ni,2)) -1*station.Zpol(2,ni,2)*sin(station.Zpol(1,ni,2));...
        sin(station.Zpol(1,ni,2)) station.Zpol(2,ni,2)*cos(station.Zpol(1,ni,2))];
    R1_2(:,:,ni) = A1_2*[station.Rpol(2,2,2) 0;0 station.Rpol(1,1,2)]*A1_2';
    A1_3 = [cos(station.Zpol(1,ni,3)) -1*station.Zpol(2,ni,3)*sin(station.Zpol(1,ni,3));...
        sin(station.Zpol(1,ni,3)) station.Zpol(2,ni,3)*cos(station.Zpol(1,ni,3))];
    R1_3(:,:,ni) = A1_3*[station.Rpol(2,2,3) 0;0 station.Rpol(1,1,3)]*A1_3';
    Jz(:,:,ni) = H'*inv(R1_1(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H;
    J(:,:,ni) = inv(target.Q + F*inv(J(:,:,ni-1))*F')+Jz(:,:,ni);
    PCRBci(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

PCRB1E = posteriorCramerRaoLowerBound(target.Q,target.dt,station.Rpol,station.Hjcob,station.Zcart,station.origin,station.PE,"EKF");

J = zeros(4,4,target.frame);
J(:,:,1) = eye(4);
PCRBciE = zeros(target.frame,1);
PCRBciE(1,1) = 1;

for ni = 2:target.frame
    J(:,:,ni) = inv(target.Q + F*inv(J(:,:,ni-1))*F')+station.Hjcob(:,:,ni,1)'*inv(station.Rpol(:,:,1))*station.Hjcob(:,:,ni,1)+station.Hjcob(:,:,ni,2)'*inv(station.Rpol(:,:,2))*station.Hjcob(:,:,ni,2)+station.Hjcob(:,:,ni,3)'*inv(station.Rpol(:,:,3))*station.Hjcob(:,:,ni,3);
    PCRBciE(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

exp7_1 = figure('Name','exp7_1');
hold on;
plot(PCRB1(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达1 KF PCRB');
plot(PCRB1(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达2 KF PCRB');
plot(PCRB1(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达3 KF PCRB');
plot(PCRBci,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','KF CI PCRB');
plot(station.Xhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 KF 滤波');
plot(station.Xhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 KF 滤波');
plot(station.Xhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 KF 滤波');
plot(station.Xhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','KF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('KF克拉美罗下界','FontSize',20);
legend();
exportgraphics(exp7_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.emf','Resolution',600);
exportgraphics(exp7_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.jpg','Resolution',600);

exp7_2 = figure('Name','exp7_2');
hold on;
plot(PCRB1E(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达1 EKF PCRB');
plot(PCRB1E(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达2 EKF PCRB');
plot(PCRB1E(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达3 EKF PCRB');
plot(PCRBciE,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','EKF CI PCRB');
plot(station.XhatE_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 EKF 滤波');
plot(station.XhatE_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 EKF 滤波');
plot(station.XhatE_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 EKF 滤波');
plot(station.XhatE_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','EKF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('EKF克拉美罗下界','FontSize',20);
legend();
exportgraphics(exp7_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_2.emf','Resolution',600);
exportgraphics(exp7_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_2.jpg','Resolution',600);
