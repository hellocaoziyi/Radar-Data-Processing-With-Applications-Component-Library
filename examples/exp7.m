clearvars -except i_exp;
close all;

load('C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp6\exp6.mat');


H = Station.H;
HE = Station.HE;
F = Target.F;
J = zeros(4,4,Target.nIter);
Jz = zeros(4,4,Target.nIter);
J(:,:,1) = inv(Target.Q(:,:,1) + Station.P_ci(:,:,1))+H'*inv(Station.R(:,:,1,1))*H + H'*inv(Station.R(:,:,1,2))*H + H'*inv(Station.R(:,:,1,3))*H;
PCRBci(1) = (trace(inv(J(:,:,1)))).^0.5;

Station = posteriorCramerRaoLowerBound(Target,Station,"KF");

for iIter = 2:Target.nIter
    Jz(:,:,iIter) = H'*inv(Station.R(:,:,iIter,1))*H + H'*inv(Station.R(:,:,iIter,2))*H + H'*inv(Station.R(:,:,iIter,3))*H;
    J(:,:,iIter) = inv(Target.Q(:,:,iIter) + F*inv(J(:,:,iIter-1))*F')+Jz(:,:,iIter);
    PCRBci(iIter) = (trace(inv(J(:,:,iIter)))).^0.5;
end

Station = posteriorCramerRaoLowerBound(Target,Station,"EKF");

J = zeros(4,4,Target.nIter);
PCRBciE = zeros(Target.nIter,1);
J(:,:,1) = inv(Target.Q(:,:,1) + Station.PE_ci(:,:,1))+HE(:,:,1,1)'*inv(Station.R(:,:,1,1))*HE(:,:,1,1)...
    + HE(:,:,1,2)'*inv(Station.R(:,:,1,2))*HE(:,:,1,2) + HE(:,:,1,3)'*inv(Station.R(:,:,1,3))*HE(:,:,1,3);
PCRBciE(1) = (trace(inv(J(:,:,1)))).^0.5;

for iIter = 2:Target.nIter
    J(:,:,iIter) = inv(Target.Q(:,:,iIter) + F*inv(J(:,:,iIter-1))*F')...
        +Station.HE(:,:,iIter,1)'*inv(Station.Rpol(:,:,1))*Station.HE(:,:,iIter,1)...
        +Station.HE(:,:,iIter,2)'*inv(Station.Rpol(:,:,2))*Station.HE(:,:,iIter,2)...
        +Station.HE(:,:,iIter,3)'*inv(Station.Rpol(:,:,3))*Station.HE(:,:,iIter,3);
    PCRBciE(iIter) = (trace(inv(J(:,:,iIter)))).^0.5;
end

exp7_1 = figure('Name','exp7_1');
exp7_1.Visible = 'off';
hold on;
plot(Station.PCRB(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(Station.PCRB,1),'LineWidth',1,'DisplayName','雷达1 KF PCRB');
plot(Station.PCRB(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(Station.PCRB,1),'LineWidth',1,'DisplayName','雷达2 KF PCRB');
plot(Station.PCRB(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(Station.PCRB,1),'LineWidth',1,'DisplayName','雷达3 KF PCRB');
plot(PCRBci,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(Station.PCRB,1),'LineWidth',1,'DisplayName','KF CI PCRB');
plot(Station.Xhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 KF 滤波');
plot(Station.Xhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 KF 滤波');
plot(Station.Xhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 KF 滤波');
plot(Station.Xhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','KF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('KF克拉美罗下界','FontSize',20);
legend();
exportgraphics(exp7_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.emf','Resolution',600);
exportgraphics(exp7_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.jpg','Resolution',600);

exp7_2 = figure('Name','exp7_2');
exp7_2.Visible = 'off';
hold on;
plot(Station.PCRBE(:,1),'Color','#D95319','LineStyle',':','Marker','d','MarkerIndices',1:5:size(Station.PCRBE,1),'LineWidth',1,'DisplayName','雷达1 EKF PCRB');
plot(Station.PCRBE(:,2),'Color','#EDB120','LineStyle','--','Marker','d','MarkerIndices',1:5:size(Station.PCRBE,1),'LineWidth',1,'DisplayName','雷达2 EKF PCRB');
plot(Station.PCRBE(:,3),'Color','#7E2F8E','LineStyle','-.','Marker','d','MarkerIndices',1:5:size(Station.PCRBE,1),'LineWidth',1,'DisplayName','雷达3 EKF PCRB');
plot(PCRBciE,'Color','#77AC30','LineStyle','-','Marker','d','MarkerIndices',1:5:size(Station.PCRBE,1),'LineWidth',1,'DisplayName','EKF CI PCRB');
plot(Station.XEhat_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',1,'DisplayName','雷达1 EKF 滤波');
plot(Station.XEhat_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',1,'DisplayName','雷达2 EKF 滤波');
plot(Station.XEhat_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',1,'DisplayName','雷达3 EKF 滤波');
plot(Station.XEhat_ci_monte(1,:),'Color','#77AC30','LineStyle','-','LineWidth',1,'DisplayName','EKF 滤波 CI 融合');
grid on;
xlabel('仿真时间/s','FontSize',20); 
ylabel('RMSE/m','FontSize',20);
title('EKF克拉美罗下界','FontSize',20);
legend();
exportgraphics(exp7_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_2.emf','Resolution',600);
exportgraphics(exp7_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_2.jpg','Resolution',600);

exp7_1.Visible = 'on';
exp7_2.Visible = 'on';