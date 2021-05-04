function station = posteriorCramerRaoLowerBound(target,station,mode)
%POSTERIORCRAMERRAOLOWERBOUND 此处显示有关此函数的摘要
%INPUT: Q：一个4X4的矩阵，状态协方差矩阵
%       k：仿真步数
%       R：量测协方差矩阵,2X2的矩阵
%       F：状态转移矩阵
%       H：量测转移矩阵

if mode == "KF"
    Q = target.Q;
    T = target.dt;
    Rpol = station.Rpol;
    H = station.H;
    Z = station.Zcart;
    origin = station.origin;
    P = station.P;
    
    F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
    
    frame = size(Z,2);
    origin_total = size(Rpol,3);
    J = zeros(4,4,frame,origin_total);
    PCRBdata = zeros(frame,origin_total);
    for origin_num = 1:origin_total
        
        Z(1,:,origin_num) = Z(1,:,origin_num) - origin(1,origin_num);
        Z(2,:,origin_num) = Z(2,:,origin_num) - origin(2,origin_num);
        
        Zpol = cartesian2Polar(Z(1,1,origin_num),Z(2,1,origin_num));
        A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
            sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
        R(:,:,1,origin_num) = A*[Rpol(2,2,origin_num) 0;0 Rpol(1,1,origin_num)]*A';
        
        J(:,:,1,origin_num) =inv(Q + P(:,:,1,origin_num))+H'*inv(R(:,:,1,origin_num))*H;
        PCRBdata(1,origin_num) = (trace(inv(J(:,:,1,origin_num)))).^0.5;
        
        for ni = 2:frame
            Zpol = cartesian2Polar(Z(1,ni,origin_num),Z(2,ni,origin_num));
            A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
                sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
            R(:,:,ni,origin_num) = A*[Rpol(2,2,origin_num) 0;0 Rpol(1,1,origin_num)]*A';
            J(:,:,ni,origin_num) = inv(Q + F*inv(J(:,:,ni-1,origin_num))*F')+H'*inv(R(:,:,ni,origin_num))*H;
            PCRBdata(ni,origin_num) = (trace(inv(J(:,:,ni,origin_num)))).^0.5;
        end
    end
    
    station.PCRB = PCRBdata;
    
elseif mode == "EKF"

    Q = target.Q;
    T = target.dt;
    Rpol = station.Rpol;
    H = station.Hjcob;
    Z = station.Zcart;
    P = station.PE;
    
    F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
    
    frame = size(Z,2);
    origin_total = size(Rpol,3);
    J = zeros(4,4,frame,origin_total);
    PCRBdata = zeros(frame,origin_total);
    for origin_num = 1:origin_total
        J(:,:,1,origin_num) =inv(Q + P(:,:,1,origin_num))++H(:,:,1,origin_num)'*inv(Rpol(:,:,origin_num))*H(:,:,1,origin_num);
        PCRBdata(1,origin_num) = (trace(inv(J(:,:,1,origin_num)))).^0.5;
        for ni = 2:frame
            J(:,:,ni,origin_num) = inv(Q + F*inv(J(:,:,ni-1,origin_num))*F')+H(:,:,ni,origin_num)'*inv(Rpol(:,:,origin_num))*H(:,:,ni,origin_num);
            PCRBdata(ni,origin_num) = (trace(inv(J(:,:,ni,origin_num)))).^0.5;
        end
    end
end

station.PCRBE = PCRBdata;

end

