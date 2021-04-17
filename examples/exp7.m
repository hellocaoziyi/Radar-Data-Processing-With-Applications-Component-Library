clear;
close all;
storageName1 = strcat('exp5_1','.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp5\',storageName1]);
storageName2 = strcat('exp6','.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\',storageName2]);

H = [1 0 0 0; 0 0 1 0];

PCRB1 = posteriorCramerRaoLowerBound(k,Q,T,Rpol1,H,Zcart1_1,origin1,"KF");
PCRB2 = posteriorCramerRaoLowerBound(k,Q,T,Rpol2,H,Zcart1_2,origin2,"KF");
PCRB3 = posteriorCramerRaoLowerBound(k,Q,T,Rpol3,H,Zcart1_3,origin3,"KF");

PCRB1E = posteriorCramerRaoLowerBound(k,Q,T,Rpol1,Hjcob1,Zcart1_1,origin1,"EKF");
PCRB2E = posteriorCramerRaoLowerBound(k,Q,T,Rpol2,Hjcob2,Zcart1_2,origin2,"EKF");
PCRB3E = posteriorCramerRaoLowerBound(k,Q,T,Rpol3,Hjcob3,Zcart1_3,origin3,"EKF");

hold on;
plot(PCRB1(:,1),'k','LineWidth',2,'DisplayName','雷达1 KF PCRB');
plot(PCRB2(:,1),'r','LineWidth',2,'DisplayName','雷达2 KF PCRB');
plot(PCRB3(:,1),'b','LineWidth',2,'DisplayName','雷达3 KF PCRB');
plot(Xhat1_1_monte(1,:),'k--','LineWidth',2,'DisplayName','雷达1 KF');
plot(Xhat1_2_monte(1,:),'r--','LineWidth',2,'DisplayName','雷达2 KF');
plot(Xhat1_3_monte(1,:),'b--','LineWidth',2,'DisplayName','雷达3 KF');
grid on;
legend();

figure();
hold on;
plot(PCRB1E(:,1),'k','LineWidth',2,'DisplayName','雷达1 EKF PCRB');
plot(PCRB2E(:,1),'r','LineWidth',2,'DisplayName','雷达2 EKF PCRB');
plot(PCRB3E(:,1),'b','LineWidth',2,'DisplayName','雷达3 EKF PCRB');
plot(Xhat1_1E_monte(1,:),'k--','LineWidth',2,'DisplayName','雷达1 EKF');
plot(Xhat1_2E_monte(1,:),'r--','LineWidth',2,'DisplayName','雷达2 EKF');
plot(Xhat1_3E_monte(1,:),'b--','LineWidth',2,'DisplayName','雷达3 EKF');
grid on;
legend();
