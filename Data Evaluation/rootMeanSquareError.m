function RMSE = rootMeanSquareError(Xhat,varargin)
%ROOTMEANSQUAREERROR 雷达数据处理及应用器件库-数据评估-均方根误差
%INPUT：Xhat：比较对象
%       varargin：估计值
X = 0;
for ni = 1:(nargin-1)
    X = X+(varargin{ni}-Xhat).^2;
end
averageX = X./ni;
RMSE = averageX.^0.5;
end

