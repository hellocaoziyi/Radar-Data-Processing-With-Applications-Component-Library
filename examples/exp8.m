clearvars -except i_exp;
close all;

<<<<<<< Updated upstream
run(exp8_uniform.m);
run(exp8_optimal.m);
run(exp8_draw.m);
=======
%生成相应的目标状态
Target.X0 = [1000 170 8000 -120]';
Target.q = [1^2 0;0 1^2];
Target.nIter = 40;
Target.dt = 1;

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
Station.POWERTOTAL = 4e9;
Station.powerallocation = zeros(Station.nStation,Target.nIter);
Station.powerallocation(:,1) = [Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5,Station.POWERTOTAL/5] ;
Station.H = [1 0 0 0;0 0 1 0];

Station.Xhat = zeros(4,Target.nIter,Station.nStation);
Station.FIM = zeros(4,4,Target.nIter);

sumw = zeros(1,Target.nIter);
Station.Pci = zeros(4,4,Target.nIter);
Station.Xci = zeros(4,Target.nIter);


% 生成相应的目标状态
Target = constantVelocity(Target);
Station.Xci(:,1) = Target.X(:,1);
Station = measurementNoise(Target,Station,1);
for jStation = 1:Station.nStation
    R = Station.R;
    T = Target.dt;
    Station.P(:,:,1,jStation) = [R(1,1,1,jStation)    R(1,1,1,jStation)/T      R(1,2,1,jStation)    R(1,2,1,jStation)/T
        R(1,1,1,jStation)/T  2*R(1,1,1,jStation)/T^2  R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2
        R(1,2,1,jStation)    R(1,2,1,jStation)/T      R(2,2,1,jStation)    R(2,2,1,jStation)/T
        R(1,2,1,jStation)/T  2*R(1,2,1,jStation)/T^2  R(2,2,1,jStation)/T  2*R(2,2,1,jStation)/T^2];
end
for i_ci = 1:Station.nStation
    w(1,i_ci) = trace(Station.R(:,:,1,i_ci));
    sumw(1,1) = inv(w(1,i_ci))+sumw(1,1);
end
for i_ci = 1:Station.nStation
    w(1,i_ci) = inv(w(1,i_ci))/sumw(1,1);
end
for i_ci = 1:Station.nStation
    Station.Pci(:,:,1) = Station.Pci(:,:,1) + w(1,i_ci).*inv(Station.P(:,:,1,i_ci));
end
Station.Pci(:,:,1) = inv(Station.Pci(:,:,1));
jptemp = 0;
for i_ci = 1:Station.nStation
jptemp = jptemp + Station.H'*inv(Station.R(:,:,1,i_ci))*Station.H;
end
Station.FIM(:,:,1) = inv(Target.Q(:,:,1) + Station.Pci(:,:,1))+jptemp;
Station.PCRB(1) = trace(inv(Station.FIM(:,:,1)));
Station = cartesianMeasurementSingle(Target,Station,1);

%跟踪滤波
for iIter = 2:Target.nIter
    
    %状态一步预测
    Station.Xci(:,iIter) = Target.F * Station.Xci(:,iIter-1);
    
    %选择功率联合分配
    Station = powerOptimization(Target,Station,iIter);
    Station.PCRB(iIter) = trace(inv(Station.FIM(:,:,iIter)));
    
    %根据分配功率设置量测噪声
    Station = measurementNoise(Target,Station,iIter);
    
    Station = cartesianMeasurementSingle(Target,Station,iIter);
    
    for jStation = 1:Station.nStation
        
        Station.Pminus(:,:,iIter,jStation)=Target.F*Station.P(:,:,iIter-1,jStation)*Target.F'+Target.Q(:,:,iIter);
        Station.K(:,:,iIter,jStation) = Station.Pminus(:,:,iIter,jStation)*Station.H'/(Station.H*Station.Pminus(:,:,iIter,jStation)*Station.H'+Station.R(:,:,iIter,jStation));
        Station.Xhat(:,iIter,jStation) = Station.Xci(:,iIter) + Station.K(:,:,iIter,jStation)*(Station.Z(:,iIter,jStation)-Station.H*Station.Xci(:,iIter));
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
end

exp8_1 = figure('Name','exp8_1');
imagesc(Station.powerallocation)
colormap(hot);
colorbar;
yticks([1 2 3 4 5]) 
xlabel('时刻');
ylabel('雷达标号');
title('优化资源分配图');
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.emf','Resolution',600);
exportgraphics(exp8_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.jpg','Resolution',600);


exp8_2 = figure('Name','exp8_2');
hold on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
plot(Station.Z(1,:,1),Station.Z(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
% plot(Station.Xhat(1,:,1),Station.Xhat(3,:,1),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达1 KF 滤波轨迹');
plot(Station.Xci(1,:),Station.Xci(3,:),'Color','#77AC30','LineStyle','-.','LineWidth',2,'DisplayName','KF 滤波 CI 融合后轨迹');
scatter(Station.address(1,:),Station.address(2,:),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达量测点');
title('量测轨迹和滤波轨迹和融合轨迹','FontSize',20);
xlabel('x/m','FontSize',20);
ylabel('y/m','FontSize',20);
legend();
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.emf','Resolution',600);
exportgraphics(exp8_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp7_1.jpg','Resolution',600);
>>>>>>> Stashed changes
