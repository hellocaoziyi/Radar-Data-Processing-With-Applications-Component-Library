clear;
clc;
close all;

%生成相应的目标状态
Target.X0 = [1000 170 8000 -120]';
Target.q = [5^2 0;0 5^2];
Target.nIter = 40;
Target.dt = 1;

% 生成相应的目标状态
Target = constantVelocity(Target);

nMonte = 3;
for iMonte = 1:nMonte

    iMonte

%量测参数
% Station.address = [1400 5800;2100 4700;2800 3900;3900 3100;5100 2500]';
Station.address = [1400 5300;2100 4400;3200 3500;4400 2800;5900 2300]';
Station.nStation = size(Station.address,2);
Station.R = zeros(2,2,Target.nIter,Station.nStation);
Station.rcs = ones(Station.nStation,Target.nIter);
Station.C = 3e8;
Station.LAMDA = 0.6;
Station.FREQUENCY = Station.C/Station.LAMDA;
Station.BANDWIDTH = (1e6)*ones(Station.nStation,1);
Station.TIMEWIDTH = (1e-3)*ones(Station.nStation,1);
Station.POWERTOTAL = 4e9;
Station.powerallocation = zeros(Station.nStation,Target.nIter);
Station.powerallocation(:,1) = [Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5] ;
Station.power_he_total(1,1) = Station.POWERTOTAL;
Station.H = [1 0 0 0;0 0 1 0];
Station.Xhat = zeros(4,Target.nIter,Station.nStation);
Station.FIM = zeros(4,4,Target.nIter);
Station.Pci = zeros(4,4,Target.nIter);
Station.Xci = zeros(4,Target.nIter);
Station.sumw = zeros(1,Target.nIter);
Station.w = zeros(Station.nStation,Target.nIter);

Station1.address = [1400 5800;2100 4700;2800 3900;3900 3100;5100 2500]';
Station1.nStation = size(Station1.address,2);
Station1.R = zeros(2,2,Target.nIter,Station1.nStation);
Station1.rcs = ones(Station1.nStation,Target.nIter);
Station1.C = 3e8;
Station1.LAMDA = 0.6;
Station1.FREQUENCY = Station1.C/Station1.LAMDA;
Station1.BANDWIDTH = (1e6)*ones(Station1.nStation,1);
Station1.TIMEWIDTH = (1e-3)*ones(Station1.nStation,1);
Station1.POWERTOTAL = 4e9;
Station1.powerallocation = zeros(Station1.nStation,Target.nIter);
Station1.powerallocation(:,1) = [Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5] ;
Station1.power_he_total(1,1) = Station1.POWERTOTAL;
Station1.H = [1 0 0 0;0 0 1 0];
Station1.Xhat = zeros(4,Target.nIter,Station1.nStation);
Station1.FIM = zeros(4,4,Target.nIter);
Station1.Pci = zeros(4,4,Target.nIter);
Station1.Xci = zeros(4,Target.nIter);
Station1.sumw = zeros(1,Target.nIter);
Station1.w = zeros(Station1.nStation,Target.nIter);

Station = measurementNoise(Target,Station,1);
Station1 = measurementNoise(Target,Station1,1);
Station = cartesianMeasurementSingle(Target,Station,1);
Station1 = cartesianMeasurementSingle(Target,Station1,1);
for jStation = 1:Station.nStation
    R = Station.R;
    T = Target.dt;
    Station.P(:,:,1,jStation) = [R(1,1,1,jStation)    R(1,1,1,jStation)/T      R(1,2,1,jStation)    R(1,2,1,jStation)/T
        R(1,1,1,jStation)/T  2*R(1,1,1,jStation)/T^2  R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2
        R(1,2,1,jStation)    R(1,2,1,jStation)/T      R(2,2,1,jStation)    R(2,2,1,jStation)/T
        R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2  R(2,2,1,jStation)/T  2*R(2,2,1,jStation)/T^2];
end
for jStation = 1:Station1.nStation
    R = Station1.R;
    T = Target.dt;
    Station1.P(:,:,1,jStation) = [R(1,1,1,jStation)    R(1,1,1,jStation)/T      R(1,2,1,jStation)    R(1,2,1,jStation)/T
        R(1,1,1,jStation)/T  2*R(1,1,1,jStation)/T^2  R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2
        R(1,2,1,jStation)    R(1,2,1,jStation)/T      R(2,2,1,jStation)    R(2,2,1,jStation)/T
        R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2  R(2,2,1,jStation)/T  2*R(2,2,1,jStation)/T^2];
end
for i_ci = 1:Station.nStation
    Station.w(i_ci,1) = trace(Station.R(:,:,1,i_ci));
    Station.sumw(1,1) = inv(Station.w(i_ci,1))+Station.sumw(1,1);
end
for i_ci = 1:Station1.nStation
    Station1.w(i_ci,1) = trace(Station1.R(:,:,1,i_ci));
    Station1.sumw(1,1) = inv(Station1.w(i_ci,1))+Station1.sumw(1,1);
end
for i_ci = 1:Station.nStation
    Station.w(i_ci,1) = inv(Station.w(i_ci,1))/Station.sumw(1,1);
end
for i_ci = 1:Station1.nStation
    Station1.w(i_ci,1) = inv(Station1.w(i_ci,1))/Station1.sumw(1,1);
end
for i_ci = 1:Station.nStation
    Station.Pci(:,:,1) = Station.Pci(:,:,1) + Station.w(i_ci,1).*inv(Station.P(:,:,1,i_ci));
end
for i_ci = 1:Station1.nStation
    Station1.Pci(:,:,1) = Station1.Pci(:,:,1) + Station1.w(i_ci,1).*inv(Station1.P(:,:,1,i_ci));
end
Station.Pci(:,:,1) = inv(Station.Pci(:,:,1));
Station1.Pci(:,:,1) = inv(Station1.Pci(:,:,1));
Xci = 0;
for i_ci = 1:Station.nStation
    Station.Xhat(:,1,i_ci) = [Station.Z(1,1,i_ci) 0 Station.Z(2,1,i_ci) 0]';
    Xci = Xci + Station.w(i_ci,1).*inv(Station.P(:,:,1,i_ci))*Station.Xhat(:,1,i_ci);
end
Station.Xci(:,1)   = Station.Pci(:,:,1)*Xci;
Xci = 0;
for i_ci = 1:Station1.nStation
    Station1.Xhat(:,1,i_ci) = [Station1.Z(1,1,i_ci) 0 Station1.Z(2,1,i_ci) 0]';
    Xci = Xci + Station1.w(i_ci,1).*inv(Station1.P(:,:,1,i_ci))*Station1.Xhat(:,1,i_ci);
end
Station1.Xci(:,1)   = Station1.Pci(:,:,1)*Xci;
Station.jptemp = 0;
Station1.jptemp = 0;
for i_ci = 1:Station.nStation
    Station.jptemp = Station.jptemp + Station.H'*inv(Station.R(:,:,1,i_ci))*Station.H;
end
for i_ci = 1:Station1.nStation
    Station1.jptemp = Station1.jptemp + Station1.H'*inv(Station1.R(:,:,1,i_ci))*Station1.H;
end
Station.FIM(:,:,1) = inv(Target.Q(:,:,1) + Station.Pci(:,:,1))+Station.jptemp;
Station1.FIM(:,:,1) = inv(Target.Q(:,:,1) + Station1.Pci(:,:,1))+Station1.jptemp;
Station.PCRB(1) = trace(inv(Station.FIM(:,:,1))).^0.5;
Station1.PCRB(1) = trace(inv(Station1.FIM(:,:,1))).^0.5;

%跟踪滤波
for iIter = 2:Target.nIter
    
    %状态一步预测
    Station.Xci(:,iIter) = Target.F * Station.Xci(:,iIter-1);
    Station1.Xci(:,iIter) = Target.F * Station1.Xci(:,iIter-1);
    
    %选择功率联合分配
    Station = powerOptimization(Target,Station,iIter);
    Station.PCRB(iIter) = trace(inv(Station.FIM(:,:,iIter))).^0.5;
    
    Station1.powerallocation(:,iIter) = [Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5,Station1.POWERTOTAL/5] ;
    Station1.power_he_total(1,iIter) = Station1.POWERTOTAL;
    
    %根据分配功率设置量测噪声
    Station = measurementNoise(Target,Station,iIter);
    Station1 = measurementNoise(Target,Station1,iIter);
    
    Station1.FIM(:,:,iIter) = inv(Target.Q(:,:,iIter)+Target.F*inv(Station1.FIM(:,:,iIter-1))*Target.F') + ...
        Station1.H'*inv(Station1.R(:,:,iIter,1))*Station1.H + ...
        Station1.H'*inv(Station1.R(:,:,iIter,2))*Station1.H + ...
        Station1.H'*inv(Station1.R(:,:,iIter,3))*Station1.H;
    Station1.PCRB(iIter) = trace(inv(Station1.FIM(:,:,iIter))).^0.5;
    
    Station = cartesianMeasurementSingle(Target,Station,iIter);
    Station1 = cartesianMeasurementSingle(Target,Station1,iIter);
    
    for jStation = 1:Station.nStation
        
        Station.Xhat(:,iIter,jStation) = Target.F * Station.Xhat(:,iIter-1,jStation);
        Station.Pminus(:,:,iIter,jStation)=Target.F*Station.P(:,:,iIter-1,jStation)*Target.F'+Target.Q(:,:,iIter);
        Station.K(:,:,iIter,jStation) = Station.Pminus(:,:,iIter,jStation)*Station.H'/(Station.H*Station.Pminus(:,:,iIter,jStation)*Station.H'+Station.R(:,:,iIter,jStation));
        Station.Xhat(:,iIter,jStation) = Station.Xhat(:,iIter,jStation) + Station.K(:,:,iIter,jStation)*(Station.Z(:,iIter,jStation)-Station.H*Station.Xhat(:,iIter,jStation));
        Station.P(:,:,iIter,jStation) = (eye(4)-Station.K(:,:,iIter,jStation)*Station.H)*Station.Pminus(:,:,iIter,jStation)*(eye(4)+Station.K(:,:,iIter,jStation)*Station.H)'-Station.K(:,:,iIter,jStation)*Station.R(:,:,iIter,jStation)*Station.K(:,:,iIter,jStation)';
        
    end
    for jStation = 1:Station1.nStation
        
        Station1.Xhat(:,iIter,jStation) = Target.F * Station1.Xhat(:,iIter-1,jStation);
        Station1.Pminus(:,:,iIter,jStation)=Target.F*Station1.P(:,:,iIter-1,jStation)*Target.F'+Target.Q(:,:,iIter);
        Station1.K(:,:,iIter,jStation) = Station1.Pminus(:,:,iIter,jStation)*Station1.H'/(Station1.H*Station1.Pminus(:,:,iIter,jStation)*Station1.H'+Station1.R(:,:,iIter,jStation));
        Station1.Xhat(:,iIter,jStation) = Station1.Xhat(:,iIter,jStation) + Station1.K(:,:,iIter,jStation)*(Station1.Z(:,iIter,jStation)-Station1.H*Station1.Xhat(:,iIter,jStation));
        Station1.P(:,:,iIter,jStation) = (eye(4)-Station1.K(:,:,iIter,jStation)*Station1.H)*Station1.Pminus(:,:,iIter,jStation)*(eye(4)+Station1.K(:,:,iIter,jStation)*Station1.H)'-Station1.K(:,:,iIter,jStation)*Station1.R(:,:,iIter,jStation)*Station1.K(:,:,iIter,jStation)';
        
    end
    for i_ci = 1:Station.nStation
        Station.w(i_ci,iIter) = trace(Station.R(:,:,iIter,i_ci));
        Station.sumw(1,iIter) = inv(Station.w(i_ci,iIter))+Station.sumw(1,iIter);
    end
    for i_ci = 1:Station1.nStation
        Station1.w(i_ci,iIter) = trace(Station1.R(:,:,iIter,i_ci));
        Station1.sumw(1,iIter) = inv(Station1.w(i_ci,iIter))+Station1.sumw(1,iIter);
    end
    for i_ci = 1:Station.nStation
        Station.w(i_ci,iIter) = inv(Station.w(i_ci,iIter))/Station.sumw(1,iIter);
    end
    for i_ci = 1:Station1.nStation
        Station1.w(i_ci,iIter) = inv(Station1.w(i_ci,iIter))/Station1.sumw(1,iIter);
    end
    for i_ci = 1:Station.nStation
        Station.Pci(:,:,iIter) = Station.Pci(:,:,iIter) + Station.w(i_ci,iIter).*inv(Station.P(:,:,iIter,i_ci));
    end
    for i_ci = 1:Station1.nStation
        Station1.Pci(:,:,iIter) = Station1.Pci(:,:,iIter) + Station1.w(i_ci,iIter).*inv(Station1.P(:,:,iIter,i_ci));
    end
    Station.Pci(:,:,iIter) = inv(Station.Pci(:,:,iIter));
    Station1.Pci(:,:,iIter) = inv(Station1.Pci(:,:,iIter));
    Xci = 0;
    for i_ci = 1:Station.nStation
        Xci = Xci + Station.w(i_ci,iIter).*inv(Station.P(:,:,iIter,i_ci))*Station.Xhat(:,iIter,i_ci);
    end
    Station.Xci(:,iIter)   = Station.Pci(:,:,iIter)*Xci;
    Xci = 0;
    for i_ci = 1:Station1.nStation
        Xci = Xci + Station1.w(i_ci,iIter).*inv(Station1.P(:,:,iIter,i_ci))*Station1.Xhat(:,iIter,i_ci);
    end
    Station1.Xci(:,iIter)   = Station1.Pci(:,:,iIter)*Xci;
end

iMonte_powerallocation(:,:,iMonte) = Station.powerallocation;
iMonte_PCRB(:,:,iMonte) = Station.PCRB;
iMonte_PCRB1(:,:,iMonte) = Station1.PCRB;
iMonte_Xci(:,iMonte) = (Target.X(1,:) - Station.Xci(1,:)).^2 + (Target.X(3,:) - Station.Xci(3,:)).^2;
iMonte_Xci1(:,iMonte) = (Target.X(1,:) - Station1.Xci(1,:)).^2 + (Target.X(3,:) - Station1.Xci(3,:)).^2;

end

monte_powerallocation = sum(iMonte_powerallocation,3)./nMonte;
monte_PCRB = sum(iMonte_PCRB,3)./nMonte;
monte_PCRB1 = sum(iMonte_PCRB1,3)./nMonte;
monte_Xci = (sum(iMonte_Xci,2)./nMonte).^0.5;
monte_Xci1 = (sum(iMonte_Xci1,2)./nMonte).^0.5;

exp8_1 = figure('Name','exp8_1');
imagesc(Station.powerallocation)
colormap(hot);
colorbar;
yticks([1 2 3 4 5])
xlabel('时刻/s');
ylabel('雷达标号');
% title('优化资源分配图');
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_1.emf','Resolution',600);
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_1.jpg','Resolution',600);

exp8_2 = figure('Name','exp8_2');
imagesc(Station1.powerallocation)
colormap(hot);
colorbar;
caxis([min(min(Station.powerallocation)) max(max(Station.powerallocation))]);
yticks([1 2 3 4 5])
xlabel('时刻/s');
ylabel('雷达标号');
% title('平均分配图');
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_2.emf','Resolution',600);
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_2.jpg','Resolution',600);


exp8_3 = figure('Name','exp8_3');
hold on;
plot(monte_PCRB,'Color','#0072BD','LineWidth',2,'DisplayName','资源调度');
plot(monte_PCRB1,'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','均匀分配');
plot(monte_Xci,'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
plot(monte_Xci1,'Color','#7E2F8E','LineStyle','--','LineWidth',2,'DisplayName','均匀分配 KF 滤波 CI 融合后轨迹');
ylabel('RMSE/m','FontSize',20);
xlabel('仿真时刻/s','FontSize',20);
legend();
exportgraphics(exp8_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_3.emf','Resolution',600);
exportgraphics(exp8_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_3.jpg','Resolution',600);

% exp8_3 = figure('Name','exp8_3');
% hold on;
% plot(monte_Xci(1,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
% plot(monte_Xci1(1,:),'Color','#77AC30','LineWidth',2,'DisplayName','均匀分配 KF 滤波 CI 融合后轨迹');
% title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
% xlabel('x/m','FontSize',20);
% ylabel('y/m','FontSize',20);
% legend();
% exportgraphics(exp8_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.emf','Resolution',600);
% exportgraphics(exp8_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.jpg','Resolution',600);
