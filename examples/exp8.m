clear;
clc;
close all;

%生成相应的目标状态
target.X0 = [1000 170 8000 -120]';
target.q = [5^2 0;0 5^2];
target.frame = 50;
target.dt = 1;

%量测参数
station.origin = [1500 5500;4000 4000;6000 3000]';
station.num = size(station.origin,2);
station.R = zeros(2,2,target.frame,station.num);
station.rcs = ones(station.num,target.frame);
station.c = 3e8;
station.lamda = 0.6;
station.frequency = station.c/station.lamda;
station.bandwidth = (1e6)*ones(station.num,1);
station.timewidth = (1e-3)*ones(station.num,1);
station.powertotal = 1e6;
station.powerallocation = zeros(station.num,target.frame);
station.powerallocation(:,1) = [station.powertotal/3,station.powertotal/3,station.powertotal/3] ;
station.H = [1 0 0 0;0 0 1 0];

station.Xhat = zeros(4,target.frame,station.num);
station.FIM = zeros(4,4,target.frame);

sumw = zeros(1,target.frame);
station.Pci = zeros(4,4,target.frame);
station.Xci = zeros(4,target.frame);


% 生成相应的目标状态
target = constantVelocity(target);
station.Xci(:,1) = target.X(:,1);
station = measurementNoise(target,station,1);
for i_station_num = 1:station.num
    R = station.R;
    T = target.dt;
    station.P(:,:,1,i_station_num) = [R(1,1,1,i_station_num)    R(1,1,1,i_station_num)/T      R(1,2,1,i_station_num)    R(1,2,1,i_station_num)/T
        R(1,1,1,i_station_num)/T  2*R(1,1,1,i_station_num)/T^2  R(1,2,1,i_station_num)/T  2*R(1,2,1,i_station_num)/T^2
        R(1,2,1,i_station_num)    R(1,2,1,i_station_num)/T      R(2,2,1,i_station_num)    R(2,2,1,i_station_num)/T
        R(1,2,1,i_station_num)/T  2*R(1,2,1,i_station_num)/T^2  R(2,2,1,i_station_num)/T  2*R(2,2,1,i_station_num)/T^2];
end
for i_ci = 1:station.num
    w(1,i_ci) = trace(station.R(:,:,1,i_ci));
    sumw(1,1) = inv(w(1,i_ci))+sumw(1,1);
end
for i_ci = 1:station.num
    w(1,i_ci) = inv(w(1,i_ci))/sumw(1,1);
end
for i_ci = 1:station.num
    station.Pci(:,:,1) = station.Pci(:,:,1) + w(1,i_ci).*inv(station.P(:,:,1,i_ci));
end
station.Pci(:,:,1) = inv(station.Pci(:,:,1));
station.FIM(:,:,1) = inv(target.Q + station.Pci(:,:,1))+station.H'*inv(station.R(:,:,1,1))*station.H + station.H'*inv(station.R(:,:,1,2))*station.H + station.H'*inv(station.R(:,:,1,3))*station.H;
station.PCRB(1) = trace(inv(station.FIM(:,:,1)));
station = cartesianMeasurementSingle(target,station,1);

%跟踪滤波
for i_frame = 2:target.frame
    
    %状态一步预测
    station.Xci(:,i_frame) = target.F * station.Xci(:,i_frame-1);
    
    %选择功率联合分配
    station = powerOptimization(target,station,i_frame);
    station.PCRB(i_frame) = trace(inv(station.FIM(:,:,i_frame)));
    
    %根据分配功率设置量测噪声
    station = measurementNoise(target,station,i_frame);
    
    station = cartesianMeasurementSingle(target,station,i_frame);
    
    for i_station_num = 1:station.num
        
        station.Pminus(:,:,i_frame,i_station_num)=target.F*station.P(:,:,i_frame-1,i_station_num)*target.F'+target.Q;
        station.K(:,:,i_frame,i_station_num) = station.Pminus(:,:,i_frame,i_station_num)*station.H'/(station.H*station.Pminus(:,:,i_frame,i_station_num)*station.H'+station.R(:,:,i_frame,i_station_num));
        station.Xhat(:,i_frame,i_station_num) = station.Xci(:,i_frame) + station.K(:,:,i_frame,i_station_num)*(station.Z(:,i_frame,i_station_num)-station.H*station.Xci(:,i_frame));
        station.P(:,:,i_frame,i_station_num) = (eye(4)-station.K(:,:,i_frame,i_station_num)*station.H)*station.Pminus(:,:,i_frame,i_station_num);
        
    end
    for i_ci = 1:station.num
        w(i_frame,i_ci) = trace(station.R(:,:,i_frame,i_ci));
        sumw(1,i_frame) = inv(w(i_frame,i_ci))+sumw(1,i_frame);
    end
    for i_ci = 1:station.num
        w(i_frame,i_ci) = inv(w(i_frame,i_ci))/sumw(1,i_frame);
    end
    for i_ci = 1:station.num
        station.Pci(:,:,i_frame) = station.Pci(:,:,i_frame) + w(i_frame,i_ci).*inv(station.P(:,:,i_frame,i_ci));
    end
    station.Pci(:,:,i_frame) = inv(station.Pci(:,:,i_frame));
    Xci = 0;
    for i_ci = 1:station.num
        Xci = Xci + w(i_frame,i_ci).*inv(station.P(:,:,i_frame,i_ci))*station.Xhat(:,i_frame,i_ci);
    end
    station.Xci(:,i_frame)   = station.Pci(:,:,i_frame)*Xci;
end

imagesc(station.powerallocation./station.power_he_total)
colorbar;
xlabel('时刻');
ylabel('雷达标号');
title('优化资源分配图');