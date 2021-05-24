function Station = kalmanFilter(Target,Station)
%KALMANFILTER �״����ݴ���Ӧ��������-�˲���-�����˲���-�������˲�
%INPUT��Z������ֵ
%       Q��״̬Э����
%       Rpol������Э���������ֲ���
%       k�����沽��
%       T������ʱ����
%       stationAddress�����������ֱ꣨�����꣩
%       X0����ʼ״̬����ѡ��
%       P0����ʼЭ�����ѡ��
%OUTPUT��X������״̬
%        P������Э����

nIter = Target.nIter;                       %���沽��
Q = Target.Q;                               %�˶�����Э����
T = Target.dt;                              %����ʱ����
F = Target.F;                               %״̬ת�ƾ���

nStation = Station.nStation;                %�״�����
stationAddress = Station.address;           %�״�����
Rpol = Station.Rpol;                        %��������������
H = Station.H;                              %����ת�ƾ���
Zcart = Station.Zcart;                  %�������꣬�ѿ�������ϵ��ȫ������
Zpol = Station.Zpol;                    %�������꣬������ϵ���ֲ�����

X = zeros(4,nIter,nStation);                %״̬����
Xpre = zeros(4,nIter,nStation);             %״̬Ԥ��
P = zeros(4,4,nIter,nStation);              %״̬Э����
Ppre = zeros(4,4,nIter,nStation);           %״̬Э����Ԥ��
R = zeros(2,2,nIter,nStation);              %����Э����ѿ�������ϵ
K = zeros(4,2,nIter,nStation);              %�˲�����
Zpre = zeros(2,nIter,nStation);             %����Ԥ��
v = zeros(2,nIter,nStation);                %��Ϣ
S = zeros(2,2,nIter,nStation);              %��ϢЭ����

for iStation = 1:nStation
    
    %ȫ������ת��Ϊ�ֲ����꣨����״����꣩
    Zcart(1,:,iStation) = Zcart(1,:,iStation) - stationAddress(1,iStation);
    Zcart(2,:,iStation) = Zcart(2,:,iStation) - stationAddress(2,iStation);
    
    %��ʼ״̬����
    X(:,1,iStation) = ...
        [Zcart(1,1,iStation) (Zcart(1,2,iStation)-Zcart(1,1,iStation))/T...
        Zcart(2,1,iStation) (Zcart(2,2,iStation)-Zcart(2,1,iStation))/T]';
    %����ֱ������ϵ�µ���������Э���ֱ����������Э�����ʼ����
    A = [cos(Zpol(1,1,iStation)) -1*Zpol(2,1,iStation)*sin(Zpol(1,1,iStation));...
        sin(Zpol(1,1,iStation)) Zpol(2,1,iStation)*cos(Zpol(1,1,iStation))];
    R(:,:,1,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
    %��ʼ��״̬Э�������
    P(:,:,1,iStation) = ...
    [   R(1,1,1,iStation)    R(1,1,1,iStation)/T      R(1,2,1,iStation)    R(1,2,1,iStation)/T
        R(1,1,1,iStation)/T  2*R(1,1,1,iStation)/T^2  R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2
        R(1,2,1,iStation)    R(1,2,1,iStation)/T      R(2,2,1,iStation)    R(2,2,1,iStation)/T
        R(1,2,1,iStation)/T  2*R(1,2,1,iStation)/T^2  R(2,2,1,iStation)/T  2*R(2,2,1,iStation)/T^2  ];
    
    %�˲��ӵڶ�ʱ�̿�ʼ
    for iIter = 2:nIter
        
        %״̬һ��Ԥ��
        Xpre(:,iIter,iStation) = F*X(:,iIter-1,iStation);
        %״̬Э����һ��Ԥ��
        Ppre(:,:,iIter,iStation) = F*P(:,:,iIter-1,iStation)*F' + Q(:,:,iIter);
        %����һ��Ԥ��
        Zpre(:,iIter,iStation) = H*Xpre(:,iIter,iStation);
        
        
        %����ֱ������ϵ�µ�����Э����
        A = [cos(Zpol(1,1,iStation)) -1*Zpol(2,1,iStation)*sin(Zpol(1,1,iStation));...
            sin(Zpol(1,1,iStation)) Zpol(2,1)*cos(Zpol(1,1,iStation))];
        R(:,:,iIter,iStation) = A*[Rpol(2,2,iStation) 0;0 Rpol(1,1,iStation)]*A';
        
        %��Ϣ
        v(:,iIter,iStation) = Zcart(:,iIter,iStation)-Zpre(:,iIter,iStation);
        %��ϢЭ����
        S(:,:,iIter,iStation) = H*Ppre(:,:,iIter,iStation)*H'+R(:,:,iIter,iStation);
        %�˲�����
        K(:,:,iIter,iStation) = Ppre(:,:,iIter,iStation)*H'*inv(S(:,:,iIter,iStation));
        
        %״̬����
        X(:,iIter,iStation) = Xpre(:,iIter,iStation) + K(:,:,iIter,iStation)*v(:,iIter,iStation);
        %״̬Э�������
        P(:,:,iIter,iStation) = (eye(4)-K(:,:,iIter,iStation)*H)*Ppre(:,:,iIter,iStation);
%         P(:,:,iIter,iStation) = (eye(4)-K(:,:,iIter,iStation)*H)*Ppre(:,:,iIter,iStation)*(eye(4)+K(:,:,iIter,iStation)*H)'...
%             - K(:,:,iIter,iStation)*R(:,:,iIter,iStation)*K(:,:,iIter,iStation)';
        
    end
    
    %�ֲ�״̬תȫ��״̬
    X(1,:,iStation) = X(1,:,iStation) + stationAddress(1,iStation);
    X(3,:,iStation) = X(3,:,iStation) + stationAddress(2,iStation);
    
end
%�����˲����
Station.Xhat = X;
Station.P = P;
Station.R = R;
Station.S = S;
Station.v = v;
Station.Zpre = Zpre;
end