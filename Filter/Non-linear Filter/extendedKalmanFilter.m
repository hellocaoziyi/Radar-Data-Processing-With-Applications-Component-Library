function [X,P,H] = extendedKalmanFilter(Z,Q,Rpol,T,origin,X0,P0)
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
frame = size(Z,2);
origin_total = size(Rpol,3);
X = zeros(4,frame,origin_total);
Xpre = zeros(4,frame,origin_total);
P = zeros(4,4,frame,origin_total);
Pminus = zeros(4,4,frame,origin_total);
R = Rpol;
F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
K = zeros(4,2,frame,origin_total);
H = zeros(2,4,frame,origin_total);

for origin_num = 1:origin_total
    
    if nargin == 7
        X(:,1,origin_num) = X0;
        P(:,1,origin_num) = P0;
    else
        Zcart1 = polar2Cartesian(Z(1,1,origin_num),Z(2,1,origin_num));
        Zcart2 = polar2Cartesian(Z(1,2,origin_num),Z(2,2,origin_num));
        X(:,1,origin_num) = [Zcart1(1,1),(Zcart2(1,1)-Zcart1(1,1))/T,Zcart1(2,1),(Zcart2(2,1)-Zcart1(2,1))/T]';
        H(:,:,1,origin_num) = Hjacob(X(:,1,origin_num));
        A = [cos(Z(1,1,origin_num)) -1*Z(2,1,origin_num)*sin(Z(1,1,origin_num));...
            sin(Z(1,1,origin_num)) Z(2,1,origin_num)*cos(Z(1,1,origin_num))];
        R1 = A*[Rpol(2,2,origin_num) 0;0 Rpol(1,1,origin_num)]*A';
        P(:,:,1,origin_num) = [R1(1,1,1)    R1(1,1,1)/T      R1(1,2,1)    R1(1,2,1)/T
            R1(1,1,1)/T  2*R1(1,1,1)/T^2  R1(1,2,1)/T  2*R1(1,2,1)/T^2
            R1(1,2,1)    R1(1,2,1)/T      R1(2,2,1)    R1(2,2,1)/T
            R1(1,2,1)/T  2*R1(1,2,1)/T^2  R1(2,2,1)/T  2*R1(2,2,1)/T^2];
    end
    
    Zpol = zeros(2,frame);
    Zpol(:, 1) = cartesian2Polar( X(1,1,origin_num),X(3,1,origin_num));
    
    for ni = 2:frame
        
        H(:,:,ni,origin_num) = Hjacob(X(:,ni-1,origin_num));
        
        Xpre(:,ni,origin_num) = F*X(:,ni-1,origin_num);
        Pminus(:,:,ni,origin_num) = F*P(:,:,ni-1,origin_num)*F' + Q;
        
        K(:,:,ni,origin_num) = Pminus(:,:,ni,origin_num)*H(:,:,ni,origin_num)'*inv(H(:,:,ni,origin_num)*Pminus(:,:,ni,origin_num)*H(:,:,ni,origin_num)'+R(:,:,origin_num));
        
        Zpol(:,ni) = cartesian2Polar(Xpre(1,ni,origin_num),Xpre(3,ni,origin_num));
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
        
        
        X(:,ni,origin_num) = Xpre(:,ni,origin_num) + K(:,:,ni,origin_num)*(Z(:,ni,origin_num)-Zpol(:,ni));
        P(:,:,ni,origin_num) = Pminus(:,:,ni,origin_num)-K(:,:,ni,origin_num)*H(:,:,ni,origin_num)*Pminus(:,:,ni,origin_num);
    end
    
    X(1,:,origin_num) = X(1,:,origin_num) + origin(1,origin_num);
    X(3,:,origin_num) = X(3,:,origin_num) + origin(2,origin_num);
    
end

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