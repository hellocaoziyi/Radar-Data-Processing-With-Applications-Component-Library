function station = kalmanFilter(target,station)
%KALMANFILTER �״����ݴ���Ӧ��������-�˲���-�����˲���-�������˲�
%INPUT��Z������ֵ
%       Q��״̬Э����
%       Rpol������Э���������ֲ���
%       k�����沽��
%       T������ʱ����
%       origin�����������ֱ꣨�����꣩
%       X0����ʼ״̬����ѡ��
%       P0����ʼЭ�����ѡ��
%OUTPUT��X������״̬
%        P������Э����
frame = target.frame;
Z = station.Zcart;
Q = target.Q;
Rpol = station.Rpol;
T = target.dt;
origin = station.origin;
origin_total = station.num;

X = zeros(4,frame,origin_total);
Xpre = zeros(4,frame,origin_total);
P = zeros(4,4,frame,origin_total);
Pminus = zeros(4,4,frame,origin_total);
R = zeros(2,2,frame,origin_total);
F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
K = zeros(4,2,frame,origin_total);
H = [1 0 0 0
    0 0 1 0];

for origin_num = 1:origin_total
    
    Z(1,:,origin_num) = Z(1,:,origin_num) - origin(1,origin_num);
    Z(2,:,origin_num) = Z(2,:,origin_num) - origin(2,origin_num);
    
    if nargin == 7
        X(:,1,origin_num) = X0;
        P(:,1,origin_num) = P0;
    else
        X(:,1,origin_num) = [Z(1,1,origin_num) (Z(1,2,origin_num)-Z(1,1,origin_num))/T Z(2,1,origin_num) (Z(2,2,origin_num)-Z(2,1,origin_num))/T]';
        Zpol = cartesian2Polar(Z(1,1,origin_num),Z(2,1,origin_num));
        A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
            sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
        R(:,:,1,origin_num) = A*[Rpol(2,2,origin_num) 0;0 Rpol(1,1,origin_num)]*A';
        P(:,:,1,origin_num) = [R(1,1,1,origin_num)    R(1,1,1,origin_num)/T      R(1,2,1,origin_num)    R(1,2,1,origin_num)/T
            R(1,1,1,origin_num)/T  2*R(1,1,1,origin_num)/T^2  R(1,2,1,origin_num)/T  2*R(1,2,1,origin_num)/T^2
            R(1,2,1,origin_num)    R(1,2,1,origin_num)/T      R(2,2,1,origin_num)    R(2,2,1,origin_num)/T
            R(1,2,1,origin_num)/T  2*R(1,2,1,origin_num)/T^2  R(2,2,1,origin_num)/T  2*R(2,2,1,origin_num)/T^2];
    end
    for ni = 2:frame
        Xpre(:,ni,origin_num) = F*X(:,ni-1,origin_num);
        Pminus(:,:,ni,origin_num) = F*P(:,:,ni-1,origin_num)*F' + Q;
        
        Zpol = cartesian2Polar(Z(1,ni,origin_num),Z(2,ni,origin_num));
        A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
            sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
        R(:,:,ni,origin_num) = A*[Rpol(2,2,origin_num) 0;0 Rpol(1,1,origin_num)]*A';
        
        K(:,:,ni,origin_num) = Pminus(:,:,ni,origin_num)*H'/(H*Pminus(:,:,ni,origin_num)*H'+R(:,:,ni,origin_num));
        X(:,ni,origin_num) = Xpre(:,ni,origin_num) + K(:,:,ni,origin_num)*(Z(:,ni,origin_num)-H*Xpre(:,ni,origin_num));
        P(:,:,ni,origin_num) = (eye(4)-K(:,:,ni,origin_num)*H)*Pminus(:,:,ni,origin_num);
    end
    
    X(1,:,origin_num) = X(1,:,origin_num) + origin(1,origin_num);
    X(3,:,origin_num) = X(3,:,origin_num) + origin(2,origin_num);
    
end
station.Xhat = X;
station.P = P;
end