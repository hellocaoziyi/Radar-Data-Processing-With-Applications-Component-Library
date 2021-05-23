function Station = cartesianMeasurementSingle(Target,Station,iIter)
%CARTESIANMEASUREMENTSINGLE 雷达数据处理及应用器件库-系统模型-量测方程-直角坐标量测模型
%INPUTS：targets：目标运动轨迹
%        k：仿真步数
%        R：量测协方差
%OUTPUTS：Z：量测轨迹
for iStation = 1:Station.nStation
    delta = (Station.R(:,:,iIter,iStation)).^0.5;
    Station.Z(:,iIter,iStation) = Station.H*Target.X(:,iIter);
    Station.Z(1,iIter,iStation) = Station.Z(1,iIter,iStation) + delta(1,1)*randn(1,1);
    Station.Z(2,iIter,iStation) = Station.Z(2,iIter,iStation) + delta(2,2)*randn(1,1);
end
end