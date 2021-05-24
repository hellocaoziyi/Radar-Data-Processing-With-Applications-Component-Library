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

nIter = Target.nIter;                       %仿真步数
Q = Target.Q;                               %运动噪声协方差
T = Target.dt;                              %采样时间间隔
F = Target.F;                               %状态转移矩阵

nStation = Station.nStation;                %雷达数量
stationAddress = Station.address;           %雷达坐标
Rpol = Station.Rpol;                        %极坐标量测噪声
H = Station.H;                              %量测转移矩阵
Zcart = Station.Zcart;                  %量测坐标，笛卡尔坐标系，全局坐标
Zpol = Station.Zpol;                    %量测坐标，极坐标系，局部坐标

X = zeros(4,nIter,nStation);                %状态估计
Xpre = zeros(4,nIter,nStation);             %状态预测
P = zeros(4,4,nIter,nStation);              %状态协方差
Ppre = zeros(4,4,nIter,nStation);           %状态协方差预测
R = zeros(2,2,nIter,nStation);              %量测协方差，笛卡尔坐标系
K = zeros(4,2,nIter,nStation);              %滤波增益
Zpre = zeros(2,nIter,nStation);             %量测预测
v = zeros(2,nIter,nStation);                %新息
S = zeros(2,2,nIter,nStation);              %新息协方差

for iStation = 1:nStation
    
    %全局坐标转换为局部坐标（相对雷达坐标）
    Zcart(1,:,iStation) = Zcart(1,:,iStation) - stationAddress(1,iStation);
    Zcart(2,:,iStation) = Zcart(2,:,iStation) - stationAddress(2,iStation);
    
    %初始状态估计
    X(:,1,iStation) = ...
        [Zcart(1,1,iStation) (Zcart(1,2,iStation)-Zcart(1,1,iStation))/T...
        Zcart(2,1,iStation) (Zcart(2,2,iStation)-Zcart(2,1,iStation))/T]';
    %计算直角坐标系下的量测噪声协方差（直角坐标量测协方差初始化）
    A = [cos(Zpol(1,1,iStation)) -1*Zpol(2,1,iStation)*sin(Zpol(1,1,iStation));...
        sin(Zpol(1,1,iStation)) Zpol(2,1,iStation)*cos(Zpol(1,1,iStation))];
    R(:,:,1,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
    %初始化状态协方差矩阵
    P(:,:,1,iStation) = ...
    [   R(1,1,1,iStation)    R(1,1,1,iStation)/T      R(1,2,1,iStation)    R(1,2,1,iStation)/T
        R(1,1,1,iStation)/T  2*R(1,1,1,iStation)/T^2  R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2
        R(1,2,1,iStation)    R(1,2,1,iStation)/T      R(2,2,1,iStation)    R(2,2,1,iStation)/T
        R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2  R(2,2,1,iStation)/T  2*R(2,2,1,iStation)/T^2  ];
    
    %滤波从第二时刻开始
    for iIter = 2:nIter
        
        %状态一步预测
        Xpre(:,iIter,iStation) = F*X(:,iIter-1,iStation);
        %状态协方差一步预测
        Ppre(:,:,iIter,iStation) = F*P(:,:,iIter-1,iStation)*F' + Q(:,:,iIter);
        %量测一步预测
        Zpre(:,iIter,iStation) = H*Xpre(:,iIter,iStation);
        
        
        %计算直角坐标系下的噪声协方差
        A = [cos(Zpol(1,1,iStation)) -1*Zpol(2,1,iStation)*sin(Zpol(1,1,iStation));...
            sin(Zpol(1,1,iStation)) Zpol(2,1)*cos(Zpol(1,1,iStation))];
        R(:,:,iIter,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
        
        %新息
        v(:,iIter,iStation) = Zcart(:,iIter,iStation)-Zpre(:,iIter,iStation);
        %新息协方差
        S(:,:,iIter,iStation) = H*Ppre(:,:,iIter,iStation)*H'+R(:,:,iIter,iStation);
        %滤波增益
        K(:,:,iIter,iStation) = Ppre(:,:,iIter,iStation)*H'*inv(S(:,:,iIter,iStation));
        
        %状态更新
        X(:,iIter,iStation) = Xpre(:,iIter,iStation) + K(:,:,iIter,iStation)*v(:,iIter,iStation);
        %状态协方差更新
        P(:,:,iIter,iStation) = (eye(4)-K(:,:,iIter,iStation)*H)*Ppre(:,:,iIter,iStation);
%         P(:,:,iIter,iStation) = (eye(4)-K(:,:,iIter,iStation)*H)*Ppre(:,:,iIter,iStation)*(eye(4)+K(:,:,iIter,iStation)*H)'...
%             - K(:,:,iIter,iStation)*R(:,:,iIter,iStation)*K(:,:,iIter,iStation)';
        
    end
    
    %局部状态转全局状态
    X(1,:,iStation) = X(1,:,iStation) + stationAddress(1,iStation);
    X(3,:,iStation) = X(3,:,iStation) + stationAddress(2,iStation);
    
end
%保存滤波结果
Station.Xhat = X;
Station.P = P;
Station.R = R;
Station.S = S;
Station.v = v;
Station.Zpre = Zpre;
end