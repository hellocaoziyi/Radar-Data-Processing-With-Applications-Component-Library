function station = rootMeanSquareError(target,station)
%ROOTMEANSQUAREERROR 雷达数据处理及应用器件库-数据评估-均方根误差
%待解决
X = (station.Xhat-target.X).^2;
averageX = X./ni;
station.RMSE = averageX.^0.5;
end

