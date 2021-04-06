function X = polar2Cartesian(theta,rho)
%POLAR2CARTESIAN 雷达数据处理及应用器件库-量测预处理-空间配准-坐标转换-极坐标转直角坐标
%   此处显示详细说明
% theta = theta-pi;
x = rho.*cos(theta);
y = rho.*sin(theta);
X = [x y]';
end