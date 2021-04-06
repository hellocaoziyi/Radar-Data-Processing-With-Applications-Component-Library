function [Xci,Pci] = covarianceIntersection(varargin)
%COVARIANCEINTERSECTION 雷达数据处理及应用器件库-数据融合-协方差交叉
%INPUT：varargin{ni*3-2}：状态估计矩阵
%       varargin{ni*3-1}：状态估计协方差矩阵
%       varargin{ni*3}：状态估计权重
%OUTPUT：Xci：融合后状态估计矩阵
%        Pci：融合后状态估计协方差矩阵
if (mod(nargin,3)) == 0
    if nargin>=6
        groups = nargin/3;
        w = zeros(1,groups);
        sumw = 0;
        for ni = 1:groups
            w(1,ni) = inv(varargin{ni*3});
            sumw = w(1,ni)+sumw;
        end
        k = size(varargin{1},2);
        Pci = zeros(4,4,k);
        Xci = zeros(4,k);
        for ni = 1:k
            for nj = 1:groups
                Pci(:,:,ni) = Pci(:,:,ni) + (w(1,nj)/sumw).*inv(varargin{nj*3-1}(:,:,ni));
            end
            Pci(:,:,ni) = inv(Pci(:,:,ni));
        end
        for ni = 1:k
            for nj = 1:groups
                Xci(:,ni) = Xci(:,ni) + (w(1,nj)/sumw).*inv(varargin{nj*3-1}(:,:,ni))*varargin{nj*3-2}(:,ni);
            end
            Xci(:,ni)   = Pci(:,:,ni)*Xci(:,ni);
        end
    else
        msg = '输入参数数量错误，参数数量应该至少包含两组数据，即最少6个变量';
        error(msg);
    end
else
    msg = '输入参数数量错误，参数数量应该是3的倍数';
    error(msg);
end
end