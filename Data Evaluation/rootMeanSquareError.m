function station = rootMeanSquareError(target,station)
%ROOTMEANSQUAREERROR �״����ݴ���Ӧ��������-��������-���������
%�����
X = (station.Xhat-target.X).^2;
averageX = X./ni;
station.RMSE = averageX.^0.5;
end

