function station = covarianceIntersection(target,station)
%COVARIANCEINTERSECTION 雷达数据处理及应用器件库-数据融合-协方差交叉
%INPUT：varargin{ni*3-2}：状态估计矩阵
%       varargin{ni*3-1}：状态估计协方差矩阵
%       varargin{ni*3}：状态估计权重
%OUTPUT：Xci：融合后状态估计矩阵
%        Pci：融合后状态估计协方差矩阵
groups = station.num;
k = target.frame;
w = zeros(k,groups);
sumw = zeros(1,k);
k = target.frame;
for nj = 1:k
    for ni = 1:groups
        w(nj,ni) = trace(station.R(:,:,k,ni));
        sumw(1,nj) = inv(w(nj,ni))+sumw(1,nj);
    end
end
for nj =1:k
    for ni = 1:groups
        w(nj,ni) = inv(w(nj,ni))/sumw(1,nj);
    end
end
Pci = zeros(4,4,k);
PEci = zeros(4,4,k);
Xci = zeros(4,k);
XEci = zeros(4,k);
for ni = 1:k
    for nj = 1:groups
        Pci(:,:,ni) = Pci(:,:,ni) + w(ni,nj).*inv(station.P(:,:,ni,nj));
        PEci(:,:,ni) = PEci(:,:,ni) + w(ni,nj).*inv(station.PE(:,:,ni,nj));
    end
    Pci(:,:,ni) = inv(Pci(:,:,ni));
    PEci(:,:,ni) = inv(PEci(:,:,ni));
end
for ni = 1:k
    for nj = 1:groups
        Xci(:,ni) = Xci(:,ni) + w(ni,nj).*inv(station.P(:,:,ni,nj))*station.Xhat(:,ni,nj);
        XEci(:,ni) = XEci(:,ni) + w(ni,nj).*inv(station.PE(:,:,ni,nj))*station.XhatE(:,ni,nj);
    end
    Xci(:,ni)   = Pci(:,:,ni)*Xci(:,ni);
    XEci(:,ni)   = PEci(:,:,ni)*XEci(:,ni);
end
station.Xhat_ci = Xci;
station.XhatE_ci = XEci;
station.P_ci = Pci;
station.PE_ci = PEci;