function RMSE = rootMeanSquareError(Xhat,varargin)
%ROOTMEANSQUAREERROR �״����ݴ���Ӧ��������-��������-���������
%INPUT��Xhat���Ƚ϶���
%       varargin������ֵ
X = 0;
for ni = 1:(nargin-1)
    X = X+(varargin{ni}-Xhat).^2;
end
averageX = X./ni;
RMSE = averageX.^0.5;
end

