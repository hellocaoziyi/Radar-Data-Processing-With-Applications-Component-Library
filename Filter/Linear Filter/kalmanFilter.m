function [X,P] = kalmanFilter(Z,Q,Rpol,k,T,origin,X0,P0)
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
X = zeros(4,k);
Xpre = zeros(4,k);
P = zeros(4,4,k);
Pminus = zeros(4,4,k);
R = zeros(2,2,k);
F = [1 T 0 0
    0 1 0 0
    0 0 1 T
    0 0 0 1];
K = zeros(4,2,k);
H = [1 0 0 0
    0 0 1 0];

Z(1,:) = Z(1,:) - origin(1,1);
Z(2,:) = Z(2,:) - origin(2,1);

if nargin == 8
    X(:,1) = X0;
    P(:,1) = P0;
else
    X(:,1) = [Z(1,1) (Z(1,2)-Z(1,1))/T Z(2,1) (Z(2,2)-Z(2,1))/T]';
    Zpol = cartesian2Polar(Z(1,1),Z(2,1));
    A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
        sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
    R(:,:,1) = A*Rpol*A';
    P(:,:,1) = [R(1,1,1)    R(1,1,1)/T      R(1,2,1)    R(1,2,1)/T
                R(1,1,1)/T  2*R(1,1,1)/T^2  R(1,2,1)/T  2*R(1,2,1)/T^2
                R(1,2,1)    R(1,2,1)/T      R(2,2,1)    R(2,2,1)/T
                R(1,2,1)/T  2*R(1,2,1)/T^2  R(2,2,1)/T  2*R(2,2,1)/T^2];
end
for ni = 2:k
    Xpre(:,ni) = F*X(:,ni-1);
    Pminus(:,:,ni) = F*P(:,:,ni-1)*F' + Q;
    
    Zpol = cartesian2Polar(Z(1,ni),Z(2,ni));
    A = [cos(Zpol(1,1)) -1*Zpol(2,1)*sin(Zpol(1,1));...
        sin(Zpol(1,1)) Zpol(2,1)*cos(Zpol(1,1))];
    R(:,:,ni) = A*Rpol*A';
    
    K(:,:,ni) = Pminus(:,:,ni)*H'/(H*Pminus(:,:,ni)*H'+R(:,:,ni));
    X(:,ni) = Xpre(:,ni) + K(:,:,ni)*(Z(:,ni)-H*Xpre(:,ni));
    P(:,:,ni) = (eye(4)-K(:,:,ni)*H)*Pminus(:,:,ni);
end

X(1,:) = X(1,:) + origin(1,1);
X(3,:) = X(3,:) + origin(2,1);

end