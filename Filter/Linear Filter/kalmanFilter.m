function Station = kalmanFilter(Target,Station)
%KALMANFILTER 雷达数据处理及应用器件库-滤波器-线性滤波器-卡尔曼滤波
%INPUT：Z：测量值
%       Q：状态协方差
%       Rpol：量测协方差（极坐标分布）
%       k：仿真步数
%       T：仿真时间间隔
%       stationAddress：测量点坐标（直角坐标）
%       X0：初始状态（可选）
%       P0：初始协方差（可选）
%OUTPUT：X：估计状态
%        P：估计协方差
nIter = Target.nIter;
Z = Station.Zcart;
Q = Target.Q;
Rpol = Station.Rpol;
T = Target.dt;
stationAddress = Station.address;
nStation = Station.nStation;

X = zeros(4,nIter,nStation);
Xpre = zeros(4,nIter,nStation);
P = zeros(4,4,nIter,nStation);
Pminus = zeros(4,4,nIter,nStation);
R = zeros(2,2,nIter,nStation);
F = Target.F;
K = zeros(4,2,nIter,nStation);
H = Station.H;

for iStation = 1:nStation
    
    Z(1,:,iStation) = Z(1,:,iStation) - stationAddress(1,iStation);
    Z(2,:,iStation) = Z(2,:,iStation) - stationAddress(2,iStation);
    
    X(:,1,iStation) = [Z(1,1,iStation) (Z(1,2,iStation)-Z(1,1,iStation))/T Z(2,1,iStation) (Z(2,2,iStation)-Z(2,1,iStation))/T]';
    Zpol = cartesian2Polar(Z(1,1,iStation),Z(2,1,iStation));
    A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
        sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
    R(:,:,1,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
    P(:,:,1,iStation) = [R(1,1,1,iStation)    R(1,1,1,iStation)/T      R(1,2,1,iStation)    R(1,2,1,iStation)/T
        R(1,1,1,iStation)/T  2*R(1,1,1,iStation)/T^2  R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2
        R(1,2,1,iStation)    R(1,2,1,iStation)/T      R(2,2,1,iStation)    R(2,2,1,iStation)/T
        R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2  R(2,2,1,iStation)/T  2*R(2,2,1,iStation)/T^2];
    
    for iIter = 2:nIter
        
        Xpre(:,iIter,iStation) = F*X(:,iIter-1,iStation);
        Pminus(:,:,iIter,iStation) = F*P(:,:,iIter-1,iStation)*F' + Q(:,:,iIter);
        
        Zpol = cartesian2Polar(Z(1,iIter,iStation),Z(2,iIter,iStation));
        A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
            sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
        R(:,:,iIter,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
        
        K(:,:,iIter,iStation) = Pminus(:,:,iIter,iStation)*H'/(H*Pminus(:,:,iIter,iStation)*H'+R(:,:,iIter,iStation));
        X(:,iIter,iStation) = Xpre(:,iIter,iStation) + K(:,:,iIter,iStation)*(Z(:,iIter,iStation)-H*Xpre(:,iIter,iStation));
        P(:,:,iIter,iStation) = (eye(4)-K(:,:,iIter,iStation)*H)*Pminus(:,:,iIter,iStation);
        
    end
    
    X(1,:,iStation) = X(1,:,iStation) + stationAddress(1,iStation);
    X(3,:,iStation) = X(3,:,iStation) + stationAddress(2,iStation);
    
end

Station.Xhat = X;
Station.P = P;
Station.R = R;
end