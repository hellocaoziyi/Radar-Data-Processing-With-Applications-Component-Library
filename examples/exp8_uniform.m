clear;
clc;
close all;

%生成相应的目标状态
Target.X0 = [1000 170 8000 -120]';
Target.q = [1^2 0;0 1^2];
Target.nIter = 50;
Target.dt = 1;

Target = constantVelocity(Target);

nMonte = 20;
iMonte_Xci = zeros(Target.nIter,nMonte);
for iMonte = 1:nMonte
    
    % 生成相应的目标状态
    Target = constantVelocity(Target);
    
    %量测参数
    Station.address = [1400 5800;2100 4700;2800 3900;3900 3100;5100 2500]';
    Station.nStation = size(Station.address,2);
    Station.R = zeros(2,2,Target.nIter,Station.nStation);
    Station.rcs = ones(Station.nStation,Target.nIter);
    Station.C = 3e8;
    Station.LAMDA = 0.6;
    Station.FREQUENCY = Station.C/Station.LAMDA;
    Station.BANDWIDTH = (1e6)*ones(Station.nStation,1);
    Station.TIMEWIDTH = (1e-3)*ones(Station.nStation,1);
    Station.POWERTOTAL = 5e3;
    Poweruniform = Station.POWERTOTAL/Station.nStation;
    Station.powerallocation = zeros(Station.nStation,Target.nIter);
    Station.powerallocation(:,1) = [Poweruniform,Poweruniform,Poweruniform,Poweruniform,Poweruniform] ;
    Station.powerallocation(:,2) = Station.powerallocation(:,1);
    Station.H = [1 0 0 0;0 0 1 0];
    Station.Hjcob = [1 1 0 0;0 0 1 1];
    
    Station.Xhat = zeros(4,Target.nIter,Station.nStation);
    Station.Xpre = zeros(4,Target.nIter,Station.nStation);
    Station.FIM = zeros(4,4,Target.nIter);
    
    sumw = zeros(1,Target.nIter);
    Station.Pci = zeros(4,4,Target.nIter);
    Station.Xci = zeros(4,Target.nIter);
    
    Station = measurementNoise(Target,Station,1);
    Station = cartesianMeasurementSingle(Target,Station,1);
    Station = measurementNoise(Target,Station,2);
    Station = cartesianMeasurementSingle(Target,Station,2);
    for jStation = 1:Station.nStation
        Station.Xhat(:,1,jStation) = [Station.Z(1,1,jStation) Station.Z(1,2,jStation)-Station.Z(1,1,jStation) Station.Z(2,1,jStation) Station.Z(2,2,jStation)-Station.Z(2,1,jStation)];
    end
    for jStation = 1:Station.nStation
        R = Station.R;
        T = Target.dt;
        Station.P(:,:,1,jStation) = [R(1,1,1,jStation)    R(1,1,1,jStation)/T      R(1,2,1,jStation)    R(1,2,1,jStation)/T
            R(1,1,1,jStation)/T  2*R(1,1,1,jStation)/T^2  R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2
            R(1,2,1,jStation)    R(1,2,1,jStation)/T      R(2,2,1,jStation)    R(2,2,1,jStation)/T
            R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2  R(2,2,1,jStation)/T  2*R(2,2,1,jStation)/T^2];
    end
    for i_ci = 1:Station.nStation
        w(1,i_ci) = trace(Station.P(:,:,1,i_ci));
        sumw(1,1) = inv(w(1,i_ci))+sumw(1,1);
    end
    for i_ci = 1:Station.nStation
        w(1,i_ci) = inv(w(1,i_ci))/sumw(1,1);
    end
    for i_ci = 1:Station.nStation
        Station.Pci(:,:,1) = Station.Pci(:,:,1) + w(1,i_ci).*inv(Station.P(:,:,1,i_ci));
    end
    Station.Pci(:,:,1) = inv(Station.Pci(:,:,1));
    Xci = 0;
    for i_ci = 1:Station.nStation
        Xci = Xci + w(1,i_ci).*inv(Station.P(:,:,1,i_ci))*Station.Xhat(:,1,i_ci);
    end
    Station.Xci(:,1)   = Station.Pci(:,:,1)*Xci;
    %计算PCRLB
    jptemp = 0;
    for i_ci = 1:Station.nStation
        jptemp = jptemp + Station.H'*inv(Station.R(:,:,1,i_ci))*Station.H;
    end
    Station.FIM(:,:,1) = inv(Target.Q(:,:,1) + Station.Pci(:,:,1))+jptemp;
%     Station.PCRB(1) = trace(inv(Station.FIM(:,:,1))).^0.5;
    PCRBtemp = inv(Station.FIM(:,:,1));
    Station.PCRB(1) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
    %跟踪滤波
    for iIter = 2:Target.nIter
        
        %功率均匀分配
        Station.powerallocation(:,iIter) = Station.powerallocation(:,1);
        
        %根据分配功率设置量测噪声
        Station = measurementNoise(Target,Station,iIter);
        
        Station = cartesianMeasurementSingle(Target,Station,iIter);
        
        for jStation = 1:Station.nStation
            
            Station.Xpre(:,iIter,jStation) = Target.F*Station.Xhat(:,iIter-1,jStation);
            Station.Pminus(:,:,iIter,jStation)=Target.F*Station.P(:,:,iIter-1,jStation)*Target.F'+Target.Q(:,:,iIter);
            Station.K(:,:,iIter,jStation) = Station.Pminus(:,:,iIter,jStation)*Station.H'/(Station.H*Station.Pminus(:,:,iIter,jStation)*Station.H'+Station.R(:,:,iIter,jStation));
            Station.Xhat(:,iIter,jStation) = Station.Xpre(:,iIter,jStation) + Station.K(:,:,iIter,jStation)*(Station.Z(:,iIter,jStation)-Station.H*Station.Xpre(:,iIter,jStation));
            Station.P(:,:,iIter,jStation) = (eye(4)-Station.K(:,:,iIter,jStation)*Station.H)*Station.Pminus(:,:,iIter,jStation);
            
        end
        for i_ci = 1:Station.nStation
            w(iIter,i_ci) = trace(Station.P(:,:,iIter,i_ci));
            sumw(1,iIter) = inv(w(iIter,i_ci))+sumw(1,iIter);
        end
        for i_ci = 1:Station.nStation
            w(iIter,i_ci) = inv(w(iIter,i_ci))/sumw(1,iIter);
        end
        for i_ci = 1:Station.nStation
            Station.Pci(:,:,iIter) = Station.Pci(:,:,iIter) + w(iIter,i_ci).*inv(Station.P(:,:,iIter,i_ci));
        end
        Station.Pci(:,:,iIter) = inv(Station.Pci(:,:,iIter));
        Xci = 0;
        for i_ci = 1:Station.nStation
            Xci = Xci + w(iIter,i_ci).*inv(Station.P(:,:,iIter,i_ci))*Station.Xhat(:,iIter,i_ci);
        end
        Station.Xci(:,iIter)   = Station.Pci(:,:,iIter)*Xci;
        %计算PCRLB
        jptemp = 0;
        for i_ci = 1:Station.nStation
            jptemp = jptemp + Station.H'*inv(Station.R(:,:,iIter,i_ci))*Station.H;
        end
        Station.FIM(:,:,iIter) = inv(Target.Q(:,:,iIter) + Target.F*inv(Station.FIM(:,:,iIter-1))*Target.F')+jptemp;
%         Station.PCRB(iIter) = trace(inv(Station.FIM(:,:,iIter))).^0.5;
         PCRBtemp = inv(Station.FIM(:,:,iIter));
         Station.PCRB(iIter) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
    end
    iMonte_Xci(:,iMonte) = (Target.X(1,:) - Station.Xci(1,:)).^2 + (Target.X(3,:) - Station.Xci(3,:)).^2;
    storageName = strcat('exp8_',num2str(iMonte),'.mat');
    save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp8\',storageName],...
        'Target','nMonte');
end
monte_Xci = (sum(iMonte_Xci,2)./nMonte).^0.5;

exp8_1 = figure('Name','exp8_1');
imagesc(Station.powerallocation)
colormap(hot);
c = colorbar;
c.Label.String = '发射功率（W）';
c.Label.FontSize = 20;
caxis([0 Station.POWERTOTAL]);
yticks([1 2 3 4 5])
xlabel('时刻/s','FontSize',20);
ylabel('雷达标号','FontSize',20);
% title('优化资源分配图');
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_uniform_1.emf','Resolution',600);
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_uniform_1.jpg','Resolution',600);


exp8_2 = figure('Name','exp8_2');
hold on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
plot(Station.Z(1,:,1),Station.Z(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
% plot(Station.Xhat(1,:,1),Station.Xhat(3,:,1),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达1 KF 滤波轨迹');
plot(Station.Xci(1,:),Station.Xci(3,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
scatter(Station.address(1,:),Station.address(2,:),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达量测点');
% title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
xlabel('x/m','FontSize',20);
ylabel('y/m','FontSize',20);
legend();
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_uniform_2.emf','Resolution',600);
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_uniform_2.jpg','Resolution',600);

exp8_3 = figure('Name','exp8_3');
hold on;
box on;
grid on;
plot(Station.PCRB,'Color','#0072BD','LineWidth',2,'DisplayName','PCRLB');
plot(monte_Xci,'Color','#D95319','LineWidth',2,'DisplayName','RMSE');
xlabel('时刻/s','FontSize',20);
ylabel('误差/m','FontSize',20);
legend();

PCRB_uniform = Station.PCRB;
Xci_uniform = monte_Xci;

storageName = strcat('exp8_uniform','.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp8\',storageName],...
    'PCRB_uniform','Xci_uniform');