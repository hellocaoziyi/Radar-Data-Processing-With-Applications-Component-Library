function station = cartesianMeasurementSingle(target,station,i_frame)
%CARTESIANMEASUREMENTSINGLE 雷达数据处理及应用器件库-系统模型-量测方程-直角坐标量测模型
%INPUTS：targets：目标运动轨迹
%        k：仿真步数
%        R：量测协方差
%OUTPUTS：Z：量测轨迹
for i_station_num = 1:station.num
    delta = station.R(:,:,i_frame,i_station_num).^0.5;
    station.Z(:,i_frame,i_station_num) = station.H*target.X(:,i_frame);
    station.Z(1,i_frame,i_station_num) = station.Z(1,i_frame,i_station_num) + delta(1,1)*randn(1,1);
    station.Z(2,i_frame,i_station_num) = station.Z(2,i_frame,i_station_num) + delta(2,2)*randn(1,1);
end
end