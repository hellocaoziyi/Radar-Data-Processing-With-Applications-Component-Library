function PCRBdata = posteriorCramerRaoLowerBound(k,Q,T,Rpol,H,Z,origin,mode)
%POSTERIORCRAMERRAOLOWERBOUND 此处显示有关此函数的摘要
%INPUT: Q：一个4X4的矩阵，状态协方差矩阵
%       k：仿真步数
%       R：量测协方差矩阵,2X2的矩阵
%       F：状态转移矩阵
%       H：量测转移矩阵

F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];

if mode == "KF"
    
J = zeros(4,4,k);
J(:,:,1) = eye(4);
PCRBdata = zeros(k,1);
PCRBdata(1,1) = 1;

Z(1,:) = Z(1,:) - origin(1,1);
Z(2,:) = Z(2,:) - origin(2,1);

Zpol = cartesian2Polar(Z(1,1),Z(2,1));
A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
    sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
R(:,:,1) = A*[Rpol(2,2) 0;0 Rpol(1,1)]*A';

for ni = 2:k
    Zpol = cartesian2Polar(Z(1,ni),Z(2,ni));
    A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
        sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
    R(:,:,ni) = A*[Rpol(2,2) 0;0 Rpol(1,1)]*A';
    J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+H'*inv(R(:,:,ni))*H;
    PCRBdata(ni) = (trace(inv(J(:,:,ni)))).^0.5;
end
elseif mode == "EKF"
    J = zeros(4,4,k);
    J(:,:,1) = eye(4);
    PCRBdata = zeros(k,1);
    PCRBdata(1,1) = 1;
    
    for ni = 2:k
        J(:,:,ni) = inv(Q + F*inv(J(:,:,ni-1))*F')+H(:,:,ni)'*inv(Rpol)*H(:,:,ni);
        PCRBdata(ni) = (trace(inv(J(:,:,ni)))).^0.5;
    end
end

end

