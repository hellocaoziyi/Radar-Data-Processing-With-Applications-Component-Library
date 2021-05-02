clear;
close all;
storageName1 = strcat('exp5_1','.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName1]);
storageName2 = strcat('exp6','.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName2]);

H = [1 0 0 0; 0 0 1 0];
F = [1 T 0 0
    0  1 0 0
    0 0 1 T
    0 0 0 1];
J = zeros(4,4,k);
Jz = zeros(4,4,k);
J(:,:,1) = eye(4);

PCRB1 = posteriorCramerRaoLowerBound(Q,T,Rpol,H,Zcart1,origin,"KF");

for ni = 2:k
    A1_1 = [cos(Zpol1(1,ni,1)) -1*Zpol1(2,ni,1)*sin(Zpol1(1,ni,1));...
        sin(Zpol1(1,ni,1)) Zpol1(2,ni,1)*cos(Zpol1(1,ni,1))];
    R1_1(:,:,ni) = A1_1*[Rpol(2,2,1) 0;0 Rpol(1,1,1)]*A1_1';
    A1_2 = [cos(Zpol1(1,ni,2)) -1*Zpol1(2,ni,2)*sin(Zpol1(1,ni,2));...
        sin(Zpol1(1,ni,2)) Zpol1(2,ni,2)*cos(Zpol1(1,ni,2))];
    R1_2(:,:,ni) = A1_2*[Rpol(2,2,2) 0;0 Rpol(1,1,2)]*A1_2';
    A1_3 = [cos(Zpol1(1,ni,3)) -1*Zpol1(2,ni,3)*sin(Zpol1(1,ni,3));...
        sin(Zpol1(1,ni,3)) Zpol1(2,ni,3)*cos(Zpol1(1,ni,3))];
    R1_3(:,:,ni) = A1_3*[Rpol(2,2,3) 0;0 Rpol(1,1,3)]*A1_3';
    Jz(:,:,ni) = H'*inv(R1_1(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H;
    J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+Jz(:,:,ni);
    PCRBci(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

PCRB1E = posteriorCramerRaoLowerBound(Q,T,Rpol,Hjcob,Zcart1,origin,"EKF");

J = zeros(4,4,k);
J(:,:,1) = eye(4);
PCRBciE = zeros(k,1);
PCRBciE(1,1) = 1;

for ni = 2:k
    J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+Hjcob(:,:,ni,1)'*inv(Rpol(:,:,1))*Hjcob(:,:,ni,1)+Hjcob(:,:,ni,2)'*inv(Rpol(:,:,2))*Hjcob(:,:,ni,2)+Hjcob(:,:,ni,3)'*inv(Rpol(:,:,3))*Hjcob(:,:,ni,3);
    PCRBciE(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

hold on;
plot(PCRB1(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达1 KF PCRB');
plot(PCRB1(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达2 KF PCRB');
plot(PCRB1(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达3 KF PCRB');
plot(PCRBci,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','KF CI PCRB');
plot(Xhat1_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 KF 滤波');
plot(Xhat1_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 KF 滤波');
plot(Xhat1_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 KF 滤波');
plot(Xhat1_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','KF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('KF克拉美罗下界','FontSize',20);
legend();

figure();
hold on;
plot(PCRB1E(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达1 EKF PCRB');
plot(PCRB1E(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达2 EKF PCRB');
plot(PCRB1E(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','雷达3 EKF PCRB');
plot(PCRBciE,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(PCRB1,1),'LineWidth',1,'DisplayName','EKF CI PCRB');
plot(Xhat1E_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 EKF 滤波');
plot(Xhat1E_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 EKF 滤波');
plot(Xhat1E_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 EKF 滤波');
plot(Xhat1_ciE_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','EKF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('EKF克拉美罗下界','FontSize',20);
legend();
