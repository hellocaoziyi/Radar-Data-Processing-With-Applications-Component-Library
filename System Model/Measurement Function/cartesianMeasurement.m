function Z = cartesianMeasurement(targets,k,R)
%CARTESIANMEASUREMENT 雷达数据处理及应用器件库-系统模型-量测方程-直角坐标量测模型
%INPUTS：targets：目标运动轨迹
%        k：仿真步数
%        R：量测协方差
%OUTPUTS：Z：量测轨迹
H = [1 0 0 0;0 0 1 0];
Z = zeros(2,k);
delta = chol(R);
for ni = 1:k
    Z(:,ni) = H*targets(:,ni) + (randn(1,2)*delta)';
end
end