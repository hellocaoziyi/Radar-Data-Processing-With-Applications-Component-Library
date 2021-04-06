function X = cartesian2Polar(x,y)
%CARTESIAN2POLAR 雷达数据处理及应用器件库-量测预处理-空间配准-坐标转换-直角坐标转极坐标
%INPUT: x：横坐标
%       y：极坐标
%OUTPUT:X=[theta rho]'
rho = sqrt(x^2+y^2);
theta = atan2(y,x);
% theta = theta+pi;
X = [theta rho]';
end