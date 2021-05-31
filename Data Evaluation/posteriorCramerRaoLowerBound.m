function Station = posteriorCramerRaoLowerBound(Target,Station,mode)
%POSTERIORCRAMERRAOLOWERBOUND 计算后验克拉美洛下界
%INPUT: Target:跟踪目标
%       Station：观测雷达
if mode == "KF"
    
    Q = Target.Q;
    H = Station.H;
    Z = Station.Zcart;
    address = Station.address;
    P = Station.P;   
    F =  Target.F;
    
    nIter = Target.nIter;
    nStation = Station.nStation;
    J = zeros(4,4,nIter,nStation);
    PCRBdata = zeros(nIter,nStation);
    for iStation = 1:nStation
        
        Z(1,:,iStation) = Z(1,:,iStation) - address(1,iStation);
        Z(2,:,iStation) = Z(2,:,iStation) - address(2,iStation);
        
        J(:,:,1,iStation) =inv(Q(:,:,1) + P(:,:,1,iStation))+H'*inv(Station.R(:,:,1,iStation))*H;
        PCRBtemp = inv(J(:,:,1,iStation));
        PCRBdata(1,iStation) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
        
        for jIter = 2:nIter
            J(:,:,jIter,iStation) = inv(Q(:,:,jIter) + F*inv(J(:,:,jIter-1,iStation))*F')+H'*inv(Station.R(:,:,jIter,iStation))*H;
            PCRBtemp = inv(J(:,:,jIter,iStation));
            PCRBdata(jIter,iStation) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
        end
    end
    
    Station.PCRB = PCRBdata;
    
elseif mode == "EKF"

    Q = Target.Q;
    T = Target.dt;
    Rpol = Station.Rpol;
    H = Station.HE;
    Z = Station.Zcart;
    P = Station.PE;
    
    F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
    
    nIter = size(Z,2);
    nStation = size(Rpol,3);
    J = zeros(4,4,nIter,nStation);
    PCRBdata = zeros(nIter,nStation);
    for iStation = 1:nStation
        J(:,:,1,iStation) =inv(Q(:,:,1) + P(:,:,1,iStation))++H(:,:,1,iStation)'*inv(Rpol(:,:,iStation))*H(:,:,1,iStation);
        PCRBtemp = inv(J(:,:,1,iStation));
        PCRBdata(1,iStation) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
        for jIter = 2:nIter
            J(:,:,jIter,iStation) = inv(Q(:,:,jIter) + F*inv(J(:,:,jIter-1,iStation))*F')+H(:,:,jIter,iStation)'*inv(Rpol(:,:,iStation))*H(:,:,jIter,iStation);
            PCRBtemp = inv(J(:,:,jIter,iStation));
            PCRBdata(jIter,iStation) = (PCRBtemp(1,1) + PCRBtemp(3,3)).^0.5;
        end
    end
end

Station.PCRBE = PCRBdata;

end

