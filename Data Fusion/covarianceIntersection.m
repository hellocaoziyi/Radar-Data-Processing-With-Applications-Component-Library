function [Xci,Pci] = covarianceIntersection(varargin)
%COVARIANCEINTERSECTION �״����ݴ���Ӧ��������-�����ں�-Э�����
%INPUT��varargin{ni*3-2}��״̬���ƾ���
%       varargin{ni*3-1}��״̬����Э�������
%       varargin{ni*3}��״̬����Ȩ��
%OUTPUT��Xci���ںϺ�״̬���ƾ���
%        Pci���ںϺ�״̬����Э�������
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
        msg = '��������������󣬲�������Ӧ�����ٰ����������ݣ�������6������';
        error(msg);
    end
else
    msg = '��������������󣬲�������Ӧ����3�ı���';
    error(msg);
end
end