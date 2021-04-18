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

PCRB1 = posteriorCramerRaoLowerBound(k,Q,T,Rpol1,H,Zcart1_1,origin1,"KF");
PCRB2 = posteriorCramerRaoLowerBound(k,Q,T,Rpol2,H,Zcart1_2,origin2,"KF");
PCRB3 = posteriorCramerRaoLowerBound(k,Q,T,Rpol3,H,Zcart1_3,origin3,"KF");

for ni = 2:k
    A1_1 = [cos(Zpol1_1(1,ni)) -1*Zpol1_1(2,ni)*sin(Zpol1_1(1,ni));...
        sin(Zpol1_1(1,ni)) Zpol1_1(2,ni)*cos(Zpol1_1(1,ni))];
    R1_1(:,:,ni) = A1_1*[Rpol1(2,2) 0;0 Rpol1(1,1)]*A1_1';
    A1_2 = [cos(Zpol1_2(1,ni)) -1*Zpol1_2(2,ni)*sin(Zpol1_2(1,ni));...
        sin(Zpol1_2(1,ni)) Zpol1_2(2,ni)*cos(Zpol1_2(1,ni))];
    R1_2(:,:,ni) = A1_2*[Rpol2(2,2) 0;0 Rpol2(1,1)]*A1_2';
    A1_3 = [cos(Zpol1_3(1,ni)) -1*Zpol1_3(2,ni)*sin(Zpol1_3(1,ni));...
        sin(Zpol1_3(1,ni)) Zpol1_3(2,ni)*cos(Zpol1_3(1,ni))];
    R1_3(:,:,ni) = A1_3*[Rpol3(2,2) 0;0 Rpol3(1,1)]*A1_3';
    Jz(:,:,ni) = H'*inv(R1_1(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H + H'*inv(R1_2(:,:,ni))*H;
    J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+Jz(:,:,ni);
    PCRBci(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

PCRB1E = posteriorCramerRaoLowerBound(k,Q,T,Rpol1,Hjcob1,Zcart1_1,origin1,"EKF");
PCRB2E = posteriorCramerRaoLowerBound(k,Q,T,Rpol2,Hjcob2,Zcart1_2,origin2,"EKF");
PCRB3E = posteriorCramerRaoLowerBound(k,Q,T,Rpol3,Hjcob3,Zcart1_3,origin3,"EKF");

J = zeros(4,4,k);
J(:,:,1) = eye(4);
PCRBciE = zeros(k,1);
PCRBciE(1,1) = 1;

for ni = 2:k
    J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+Hjcob1(:,:,ni)'*inv(Rpol1)*Hjcob1(:,:,ni)+Hjcob2(:,:,ni)'*inv(Rpol2)*Hjcob2(:,:,ni)+Hjcob3(:,:,ni)'*inv(Rpol3)*Hjcob3(:,:,ni);
    PCRBciE(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end

hold on;
plot(PCRB1(:,1),'k','LineWidth',2,'DisplayName','雷达1 KF PCRB');
plot(PCRB2(:,1),'r','LineWidth',2,'DisplayName','雷达2 KF PCRB');
plot(PCRB3(:,1),'b','LineWidth',2,'DisplayName','雷达3 KF PCRB');
plot(PCRBci,'m','LineWidth',2,'DisplayName','KF CI PCRB');
plot(Xhat1_1_monte(1,:),'k--','LineWidth',2,'DisplayName','雷达1 KF');
plot(Xhat1_2_monte(1,:),'r--','LineWidth',2,'DisplayName','雷达2 KF');
plot(Xhat1_3_monte(1,:),'b--','LineWidth',2,'DisplayName','雷达3 KF');
plot(Xhat1_ci_monte(1,:),'m--','LineWidth',2,'DisplayName','KF CI');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
legend();

figure();
hold on;
plot(PCRB1E(:,1),'k','LineWidth',2,'DisplayName','雷达1 EKF PCRB');
plot(PCRB2E(:,1),'r','LineWidth',2,'DisplayName','雷达2 EKF PCRB');
plot(PCRB3E(:,1),'b','LineWidth',2,'DisplayName','雷达3 EKF PCRB');
plot(PCRBciE,'m','LineWidth',2,'DisplayName','KF CI PCRB');
plot(Xhat1_1E_monte(1,:),'k--','LineWidth',2,'DisplayName','雷达1 EKF');
plot(Xhat1_2E_monte(1,:),'r--','LineWidth',2,'DisplayName','雷达2 EKF');
plot(Xhat1_3E_monte(1,:),'b--','LineWidth',2,'DisplayName','雷达3 EKF');
plot(Xhat1_ciE_monte(1,:),'m--','LineWidth',2,'DisplayName','KF CI');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
legend();
