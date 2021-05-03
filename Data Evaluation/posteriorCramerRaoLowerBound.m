function PCRBdata = posteriorCramerRaoLowerBound(Q,T,Rpol,H,Z,origin,P,mode)
%POSTERIORCRAMERRAOLOWERBOUND �˴���ʾ�йش˺�����ժҪ
%INPUT: Q��һ��4X4�ľ���״̬Э�������
%       k�����沽��
%       R������Э�������,2X2�ľ���
%       F��״̬ת�ƾ���
%       H������ת�ƾ���

F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];

if mode == "KF"
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
elseif mode == "EKF"
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

end

