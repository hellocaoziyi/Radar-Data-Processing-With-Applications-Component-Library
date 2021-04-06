function [X,P] = extendedKalmanFilter(Z,Q,Rpol,k,T,origin,X0,P0)
%EXTENDEDKALMANFILTER 雷达数据处理及应用器件库-滤波器-非线性滤波器-扩展卡尔曼滤波
%INPUT：Z：测量值
%       Q：状态协方差
%       Rpol：量测协方差（极坐标分布）
%       k：仿真步数
%       T：仿真时间间隔
%       origin：测量点坐标（直角坐标）
%       X0：初始状态（可选）
%       P0：初始协方差（可选）
%OUTPUT：X：估计状态
%        P：估计协方差
X = zeros(4,k);
Xpre = zeros(4,k);
P = zeros(4,4,k);
Pminus = zeros(4,4,k);
R = Rpol;
F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
K = zeros(4,2,k);
H = zeros(2,4,k);

% Z(1,:) = Z(1,:) - origin(1,1);
% Z(2,:) = Z(2,:) - origin(2,1);

if nargin == 8
    X(:,1) = X0;
    P(:,1) = P0;
else
    X(:,1) = [1-origin(1,1),1,1-origin(2,1),1]';
    H(:,:,1) = Hjacob(X(:,1));
    P(:,:,1) = eye(4);
end

Zpol = zeros(2,k);
Zpol(:, 1) = cartesian2Polar( X(1,1),X(3,1));

for ni = 2:k
    
    H(:,:,ni) = Hjacob(X(:,ni-1));
    
    Xpre(:,ni) = F*X(:,ni-1);
    Pminus(:,:,ni) = F*P(:,:,ni-1)*F' + Q;
    
    K(:,:,ni) = Pminus(:,:,ni)*H(:,:,ni)'*inv(H(:,:,ni)*Pminus(:,:,ni)*H(:,:,ni)'+R);
    
    Zpol(:,ni) = cartesian2Polar(Xpre(1,ni),Xpre(3,ni));
    if Zpol(1,ni-1) > 0
        modZpol = mod(Zpol(1,ni-1),2*pi);
        if modZpol > pi
            modZpol2 = modZpol - 2*pi;
            if (Zpol(1,ni) - modZpol2) > pi
                Zpol(1,ni) = Zpol(1,ni-1) - (modZpol - Zpol(1,ni));
            elseif Zpol(1,ni) < modZpol2
                Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
            else
                Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
            end
        else
            modZpol2 = modZpol;
            if (modZpol2 - Zpol(1,ni)) > pi
                Zpol(1,ni) = Zpol(1,ni-1) + (2*pi - modZpol + Zpol(1,ni));
            elseif Zpol(:,ni) < modZpol2
                Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
            else
                Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
            end
        end
    elseif Zpol(1,ni-1) < 0
        modZpol = mod(Zpol(1,ni-1),-2*pi);
        if modZpol < -pi
            modZpol2 = modZpol + 2*pi;
            if (modZpol2 - Zpol(1,ni)) > pi
                Zpol(1,ni) = Zpol(1,ni-1) + (2*pi - modZpol2 + Zpol(1,ni));
            elseif Zpol(:,ni) < modZpol2
                Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
            else
                Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
            end
        else
            modZpol2 = modZpol;
            if (Zpol(1,ni) - modZpol2) > pi
                Zpol(1,ni) = Zpol(1,ni-1) - (2*pi + modZpol2 - Zpol(1,ni));
            elseif Zpol(:,ni) > modZpol2
                Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
            else
                Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
            end
        end
    else
        modZpol = 0;
        modZpol2 = modZpol;
        Zpol(1,ni) = Zpol(1,ni) + Zpol(1,ni-1) + modZpol2;
    end
            
    
    X(:,ni) = Xpre(:,ni) + K(:,:,ni)*(Z(:,ni)-Zpol(:,ni));
    P(:,:,ni) = Pminus(:,:,ni)-K(:,:,ni)*H(:,:,ni)*Pminus(:,:,ni);
end

X(1,:) = X(1,:) + origin(1,1);
X(3,:) = X(3,:) + origin(2,1);

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