function Station = extendedKalmanFilter(Target,Station)
%EXTENDEDKALMANFILTER 雷达数据处理及应用器件库-滤波器-非线性滤波器-扩展卡尔曼滤波
%INPUT：Z：测量值
%       Q：状态协方差
%       Rpol：量测协方差（极坐标分布）
%       k：仿真步数
%       T：仿真时间间隔
%       address：测量点坐标（直角坐标）
%       X0：初始状态（可选）
%       P0：初始协方差（可选）
%OUTPUT：X：估计状态
%        P：估计协方差
Z = Station.Zpol;
Q = Target.Q;
Rpol = Station.Rpol;
T = Target.dt;
address = Station.address;
nIter = Target.nIter;
nStation = Station.nStation;

X = zeros(4,nIter,nStation);
Xpre = zeros(4,nIter,nStation);
P = zeros(4,4,nIter,nStation);
Pminus = zeros(4,4,nIter,nStation);
R = Rpol;
F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
K = zeros(4,2,nIter,nStation);
H = zeros(2,4,nIter,nStation);

for iStation = 1:nStation
    
    Zcart1 = polar2Cartesian(Z(1,1,iStation),Z(2,1,iStation));
    Zcart2 = polar2Cartesian(Z(1,2,iStation),Z(2,2,iStation));
    X(:,1,iStation) = [Zcart1(1,1),(Zcart2(1,1)-Zcart1(1,1))/T,Zcart1(2,1),(Zcart2(2,1)-Zcart1(2,1))/T]';
    H(:,:,1,iStation) = Hjacob(X(:,1,iStation));
    A = [cos(Z(1,1,iStation)) -1*Z(2,1,iStation)*sin(Z(1,1,iStation));...
        sin(Z(1,1,iStation)) Z(2,1,iStation)*cos(Z(1,1,iStation))];
    R1 = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
    P(:,:,1,iStation) = [R1(1,1,1)    R1(1,1,1)/T      R1(1,2,1)    R1(1,2,1)/T
        R1(1,1,1)/T  2*R1(1,1,1)/T^2  R1(1,2,1)/T  2*R1(1,2,1)/T^2
        R1(1,2,1)    R1(1,2,1)/T      R1(2,2,1)    R1(2,2,1)/T
        R1(1,2,1)/T  2*R1(1,2,1)/T^2  R1(2,2,1)/T  2*R1(2,2,1)/T^2];
    
    Zpol = zeros(2,nIter);
    Zpol(:, 1) = cartesian2Polar( X(1,1,iStation),X(3,1,iStation));
    
    for jIter = 2:nIter
        
        H(:,:,jIter,iStation) = Hjacob(X(:,jIter-1,iStation));
        
        Xpre(:,jIter,iStation) = F*X(:,jIter-1,iStation);
        Pminus(:,:,jIter,iStation) = F*P(:,:,jIter-1,iStation)*F' + Q(:,:,jIter);
        
        K(:,:,jIter,iStation) = Pminus(:,:,jIter,iStation)*H(:,:,jIter,iStation)'*inv(H(:,:,jIter,iStation)*Pminus(:,:,jIter,iStation)*H(:,:,jIter,iStation)'+R(:,:,iStation));
        
        Zpol(:,jIter) = cartesian2Polar(Xpre(1,jIter,iStation),Xpre(3,jIter,iStation));
        if Zpol(1,jIter-1) > 0
            modZpol = mod(Zpol(1,jIter-1),2*pi);
            if modZpol > pi
                modZpol2 = modZpol - 2*pi;
                if (Zpol(1,jIter) - modZpol2) > pi
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (modZpol - Zpol(1,jIter));
                elseif Zpol(1,jIter) < modZpol2
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (modZpol2 - Zpol(1,jIter));
                else
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (Zpol(1,jIter) - modZpol2);
                end
            else
                modZpol2 = modZpol;
                if (modZpol2 - Zpol(1,jIter)) > pi
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (2*pi - modZpol + Zpol(1,jIter));
                elseif Zpol(:,jIter) < modZpol2
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (modZpol2 - Zpol(1,jIter));
                else
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (Zpol(1,jIter) - modZpol2);
                end
            end
        elseif Zpol(1,jIter-1) < 0
            modZpol = mod(Zpol(1,jIter-1),-2*pi);
            if modZpol < -pi
                modZpol2 = modZpol + 2*pi;
                if (modZpol2 - Zpol(1,jIter)) > pi
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (2*pi - modZpol2 + Zpol(1,jIter));
                elseif Zpol(:,jIter) < modZpol2
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (modZpol2 - Zpol(1,jIter));
                else
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (Zpol(1,jIter) - modZpol2);
                end
            else
                modZpol2 = modZpol;
                if (Zpol(1,jIter) - modZpol2) > pi
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (2*pi + modZpol2 - Zpol(1,jIter));
                elseif Zpol(:,jIter) > modZpol2
                    Zpol(1,jIter) = Zpol(1,jIter-1) + (Zpol(1,jIter) - modZpol2);
                else
                    Zpol(1,jIter) = Zpol(1,jIter-1) - (modZpol2 - Zpol(1,jIter));
                end
            end
        else
            modZpol = 0;
            modZpol2 = modZpol;
            Zpol(1,jIter) = Zpol(1,jIter) + Zpol(1,jIter-1) + modZpol2;
        end
        
        
        X(:,jIter,iStation) = Xpre(:,jIter,iStation) + K(:,:,jIter,iStation)*(Z(:,jIter,iStation)-Zpol(:,jIter));
        P(:,:,jIter,iStation) = Pminus(:,:,jIter,iStation)-K(:,:,jIter,iStation)*H(:,:,jIter,iStation)*Pminus(:,:,jIter,iStation);
    end
    
    X(1,:,iStation) = X(1,:,iStation) + address(1,iStation);
    X(3,:,iStation) = X(3,:,iStation) + address(2,iStation);
    
end

Station.XEhat = X;
Station.PE = P;
Station.HE = H;

%------------------------------
    function zp = hx(xhat)
        %
        %
        zp = cartesian2Polar(xhat(1),xhat(3));
        
    end


%------------------------------
    function H = Hjacob(xp)
        %
        %
        H = zeros(2, 4);
        
        x1 = xp(1);
        x3 = xp(3);
        
        
        H(2,1) = x1 / sqrt(x1^2+x3^2);
        H(2,2) = 0;
        H(2,3) = x3 / sqrt(x1^2+x3^2);
        H(2,4) = 0;
        H(1,1) = -x3/(x1^2+x3^2);
        H(1,2) = 0;
        H(1,3) = x1/(x1^2+x3^2);
        H(1,4) = 0;
        
    end

end