clear;
clc;
close all;

%% 初始参数
Power_total = 1e6;
Mont_num = 5;
%初始化传感器的各个参数
lamda = 0.6;
sensor_location=[1500,5500;
                 4000,4000;
                 6000,3000;]; 
sensor_num=size(sensor_location,1);
sensor_bandwidth=(1e6)*ones(sensor_num,1);             %有效带宽
sensor_timewidth=(1e-3)*ones(sensor_num,1);            %有效时宽 
%初始化目标参数(单目标)
track_par.frame = 50;                                                      %总帧数
track_par.T = 1;                                                           %帧间时间间隔/s

% 匀速直线运动的模型的状态转移矩阵
track_par.F = [1     track_par.T     0             0;
               0          1          0             0;
               0          0          1      track_par.T;
               0          0          0             1];
                    
%过程噪声协方差矩阵
q1 = [5^2 0;0 5^2];
%估计状态的大小
x_state_est = zeros(4,track_par.frame);
x_state_prediction_est = zeros(4,track_par.frame);
%初始化克拉美罗参数
FIM=zeros(4,4,track_par.frame);
FIM(:,:,1)=eye(4);
%初始化选择功率联合分配参数(等功率分配)
selection=zeros(sensor_num,track_par.frame);
power_allocated=zeros(sensor_num,track_par.frame);
power_he_totel=zeros(sensor_num,track_par.frame);
power_allocated(:,1)=[Power_total/3;Power_total/3;Power_total/3]; %均匀分配功率
power_he_totel(:,1)=Power_total;
%初始化观测噪声协方差
track_R1=zeros(2,2,track_par.frame,sensor_num);

rcs=ones(sensor_num,track_par.frame);
%初始化RMSE和PCRLB
MSE=zeros(Mont_num,track_par.frame);
PCRLB_position=zeros(Mont_num,track_par.frame);

MSE1=zeros(Mont_num,track_par.frame);
PCRLB_position1=zeros(Mont_num,track_par.frame);

tic
%% 对目标进行滤波跟踪
for i_Mont=1:Mont_num;
    i_Mont
    
    % 生成相应的目标状态
    X1_0 = [1000 170 8000 -120]';
    [X1,track_par.Q] = constantVelocity(X1_0,k,T,q1); %目标状态生成
    %初始化第一帧数据
    x_state_est(:,1)=X1_0;
    Hn=[1 0 0 0;0 0 1 0;1 0 0 0;0 0 1 0;1 0 0 0;0 0 1 0];%三个雷达的量测用一个矩阵表示
    track_R0=diag([1,1,1,1,2,3,4,0.4,1,1]);%初始化协方差矩阵[1,1,1,1,2,3,4,0.4]
    P_initial=[track_R0(1,1),track_R0(1,1)/track_par.T,0,0;%滤波误差协方差矩阵
        track_R0(1,1)/track_par.T,2*track_R0(1,1)/track_par.T^2,0,0;
        0,0,track_R0(10,10),track_R0(10,10)/track_par.T;
        0,0,track_R0(10,10)/track_par.T,2*track_R0(10,10)/track_par.T^2];
    Pk=P_initial;
    Pk1=P_initial;
    measurment_noise(:,1) = sample_gaussian(zeros(length(track_R0),1),track_R0,1)';
    Z(:,1)=Hn*target_state(:,1)+measurment_noise(:,1);
    %% 跟踪滤波 by PCRLB
    for i_frame=2:track_par.frame
        
        % 状态一步预测
        
        x_state_prediction_est(:,i_frame)=track_par.F*x_state_est(:,i_frame-1);   %零过程噪声预测
        
        % 选择功率联合分配
        [power_allocated(:,i_frame),FIM(:,:,i_frame),power_he]=Power_optimization(track_par,x_state_prediction_est(:,i_frame),FIM(:,:,i_frame-1),rcs(:,i_frame));
        power_he_totel(:,i_frame)=power_he*1e3;
        [power_allocated1(:,i_frame),FIM1(:,:,i_frame)]=Power_uniform(track_par,x_state_prediction_est1(:,i_frame),FIM1(:,:,i_frame-1),rcs(:,i_frame),power_he*1e3);
        pcrlb=inv(FIM(:,:,i_frame));
        %     PCRLB_position(i_Mont,i_frame)=pcrlb(1,1)+pcrlb(3,3);
        PCRLB_position(i_Mont,i_frame)=trace(pcrlb);
        pcrlb1=inv(FIM1(:,:,i_frame));
        PCRLB_position1(i_Mont,i_frame)=trace(pcrlb1);%pcrlb1(1,1)+pcrlb1(3,3);
        
        % 量测值生成
        for i_sensor=1:size(sensor_location,1)
            
            
            track_R1(:,:,i_frame,i_sensor)=Measurement_noise_cov(target_state(:,i_frame),rcs(i_sensor,i_frame),power_allocated(i_sensor,i_frame),i_sensor);
            
            track_R11(:,:,i_frame,i_sensor)=Measurement_noise_cov(target_state(:,i_frame),rcs(i_sensor,i_frame),power_allocated1(i_sensor,i_frame),i_sensor);
            
            
        end
        track_R=diag([track_R1(1,1,i_frame,1),track_R1(2,2,i_frame,1),track_R1(1,1,i_frame,2),track_R1(2,2,i_frame,2),track_R1(1,1,i_frame,3),track_R1(2,2,i_frame,3),track_R1(1,1,i_frame,4),track_R1(2,2,i_frame,4),track_R1(1,1,i_frame,5),track_R1(2,2,i_frame,5)]);
        track_R2=diag([track_R11(1,1,i_frame,1),track_R11(2,2,i_frame,1),track_R11(1,1,i_frame,2),track_R11(2,2,i_frame,2),track_R11(1,1,i_frame,3),track_R11(2,2,i_frame,3),track_R11(1,1,i_frame,4),track_R11(2,2,i_frame,4),track_R11(1,1,i_frame,5),track_R11(2,2,i_frame,5)]);
        %四个雷达的初始量测噪声放在一个矩阵中，用于后面的量测信息确定
        % 最优融合
        
        measurment_noise(:,i_frame) = sample_gaussian(zeros(length(track_R),1),track_R,1)';
        Z(:,i_frame)=Hn*target_state(:,i_frame)+measurment_noise(:,i_frame);
        
        measurment_noise1(:,i_frame) = sample_gaussian(zeros(length(track_R2),1),track_R2,1)';
        Z1(:,i_frame)=Hn*target_state(:,i_frame)+measurment_noise1(:,i_frame);
        
        alphan=Z(:,i_frame)-Hn*x_state_prediction_est(:,i_frame);
        alphan1=Z1(:,i_frame)-Hn*x_state_prediction_est1(:,i_frame);
        
        P=track_par.F*Pk*track_par.F'+track_par.Q;%一步预测误差协方差阵
        P1=track_par.F*Pk1*track_par.F'+track_par.Q;
        
        An=Hn*P*Hn'+track_R;
        An1=Hn*P1*Hn'+track_R2;
        
        Kn=P*Hn'*inv(An);
        Kn1=P1*Hn'*inv(An1);
        x_state_est(:,i_frame)=x_state_prediction_est(:,i_frame)+Kn*alphan;
        x_state_est1(:,i_frame)=x_state_prediction_est1(:,i_frame)+Kn1*alphan1;
        Pk=(eye(4)-Kn*Hn)*P;
        Pk1=(eye(4)-Kn1*Hn)*P1;
        MSE(i_Mont,i_frame)=(x_state_est(1,i_frame)-target_state(1,i_frame))^2 + (x_state_est(3,i_frame)-target_state(3,i_frame))^2;
        MSE1(i_Mont,i_frame)=(x_state_est1(1,i_frame)-target_state(1,i_frame))^2 + (x_state_est1(3,i_frame)-target_state(3,i_frame))^2;
    end
end

%% 蒙特卡洛平均值
RMSE_opt=sqrt(mean(MSE,1));
RMSE_uniform=sqrt(mean(MSE1,1));
RMSE_opt(1)=1.5;
RMSE_uniform(1)=1.5;

PCRLB_position_opt=sqrt(mean(PCRLB_position));
PCRLB_position_uniform=sqrt(mean(PCRLB_position1));
PCRLB_position_opt(1)=1.5;
PCRLB_position_uniform(1)=1.5;

%% 画图
toc

figure(1)
plot(sensor_location(:,1),sensor_location(:,2),'o','linewidth',2)
text(sensor_location(1,1),sensor_location(1,2),'  Radar1')
text(sensor_location(2,1),sensor_location(2,2),'  Radar2')
text(sensor_location(3,1),sensor_location(3,2),'  Radar3')
text(sensor_location(4,1),sensor_location(4,2),'  Radar4')
text(sensor_location(5,1),sensor_location(5,2),'  Radar5')
hold on
plot(target_state(1,:),target_state(3,:),'ko-.','linewidth',2)
hold on
plot(x_state_est(1,:),x_state_est(3,:),'r*-','linewidth',2)
hold on
plot(x_state_est1(1,:),x_state_est1(3,:),'bd-','linewidth',2)
hold on
%   axis([0  0 track_par.y_num])
legend('雷达分布','实际位置','估计位置（Opt）','估计位置（Uniform）');
xlabel('X方向位置/km');
ylabel('Y方向位置/km');
title('目标位置的真实值和估计值');

figure(2)
plot(RMSE_uniform,'b--','linewidth',2)
hold on
plot(PCRLB_position_uniform,'-ob','linewidth',2)
hold on
plot(RMSE_opt,'r--','linewidth',2)
hold on
plot(PCRLB_position_opt,'-*r','linewidth',2)
hold on
%axis([0 30 0 800])
legend('RMSE(Uniform)','PCRLB(Uniform','RMSE(Opt)','PCRLB(Opt)');
xlabel('时刻');
ylabel('CRLB和RMSE/km');
title('目标位置均方根误差');
hold on

figure(3)
imagesc(power_allocated./power_he_totel)
colorbar;
xlabel('时刻');
ylabel('雷达标号');
title('优化资源分配图');
hold on
figure(4)
imagesc(power_allocated1./power_he_totel)
title('平均资源分配图');
hold on
%%
save hangji1 target_state%实际位置
save hangji2 x_state_est%估计位置（Opt）
save hangji3 x_state_est1%估计位置（Uniform）
save CRLB1 PCRLB_position_uniform
save CRLB2 PCRLB_position_opt
save POWER1 power_allocated%优化功率
save POWE2 power_allocated1%均匀功率
save RMSE1 RMSE_uniform
save RMSE2 RMSE_opt