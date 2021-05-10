function Station = covarianceIntersection(Target,Station)
%COVARIANCEINTERSECTION �״����ݴ���Ӧ��������-�����ں�-Э�����
%INPUT��varargin{jStation*3-2}��״̬���ƾ���
%       varargin{jStation*3-1}��״̬����Э�������
%       varargin{jStation*3}��״̬����Ȩ��
%OUTPUT��Xci���ںϺ�״̬���ƾ���
%        Pci���ںϺ�״̬����Э�������
nStation = Station.nStation;
nIter = Target.nIter;
w = zeros(nIter,nStation);
sumw = zeros(1,nIter);
for iIter = 1:nIter
    for jStation = 1:nStation
        w(iIter,jStation) = trace(Station.R(:,:,nIter,jStation));
        sumw(1,iIter) = inv(w(iIter,jStation))+sumw(1,iIter);
    end
end
for iIter =1:nIter
    for jStation = 1:nStation
        w(iIter,jStation) = inv(w(iIter,jStation))/sumw(1,iIter);
    end
end
Pci = zeros(4,4,nIter);
PEci = zeros(4,4,nIter);
Xci = zeros(4,nIter);
XEci = zeros(4,nIter);
for jStation = 1:nIter
    for iIter = 1:nStation
        Pci(:,:,jStation) = Pci(:,:,jStation) + w(jStation,iIter).*inv(Station.P(:,:,jStation,iIter));
        PEci(:,:,jStation) = PEci(:,:,jStation) + w(jStation,iIter).*inv(Station.PE(:,:,jStation,iIter));
    end
    Pci(:,:,jStation) = inv(Pci(:,:,jStation));
    PEci(:,:,jStation) = inv(PEci(:,:,jStation));
end
for jStation = 1:nIter
    for iIter = 1:nStation
        Xci(:,jStation) = Xci(:,jStation) + w(jStation,iIter).*inv(Station.P(:,:,jStation,iIter))*Station.Xhat(:,jStation,iIter);
        XEci(:,jStation) = XEci(:,jStation) + w(jStation,iIter).*inv(Station.PE(:,:,jStation,iIter))*Station.XEhat(:,jStation,iIter);
    end
    Xci(:,jStation)   = Pci(:,:,jStation)*Xci(:,jStation);
    XEci(:,jStation)   = PEci(:,:,jStation)*XEci(:,jStation);
end
Station.Xhat_ci = Xci;
Station.XEhat_ci = XEci;
Station.P_ci = Pci;
Station.PE_ci = PEci;