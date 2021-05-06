function station = powerOptimization(target,station,i_frame)
%POWEROPTIMIZATION 此处显示有关此函数的摘要
%   此处显示详细说明

%先求解黑塞矩阵
H = zeros(4,2,station.num);
for i_station_num = 1:station.num
    R(i_station_num) = sqrt((station.Xci(1,i_frame)-station.origin(1,i_station_num))^2+(station.Xci(3,i_frame)-station.origin(2,i_station_num))^2);
    H(:,1,i_station_num)=[1;target.dt;0;0];
    H(:,2,i_station_num)=[0;0;1;target.dt];
end

%优化参数
Jp=inv(target.Q+target.F*inv(station.FIM(:,:,i_frame-1))*target.F');

%功率分配
cvx_begin quiet

variable P(station.num,1)

for i_station_num = 1:station.num
    alpha_opt = 1/(((1e3*R(i_station_num))^2)^2)*station.c^2*1500;
    
    sigma2_x_opt=station.c^2/(8*pi^2*alpha_opt*(abs(station.rcs(i_station_num)))^2*station.bandwidth(i_station_num)^2);
    sigma2_y_opt=station.c^2/(8*pi^2*alpha_opt*(abs(station.rcs(i_station_num)))^2*station.bandwidth(i_station_num)^2);
    
    measurement_cov_inv_opt(:,:,i_station_num)=diag([1/sigma2_x_opt,1/sigma2_y_opt]).*1e3.* P(i_station_num,1);  %优化功率
    
    JD_opt(:,:,i_station_num)=H(:,:,i_station_num)*measurement_cov_inv_opt(:,:,i_station_num)*H(:,:,i_station_num)';
    
end

JD_sum=sum(JD_opt,3);
JK=Jp+JD_sum;

CRLB=trace_inv(JK);                    % CVX里面的写法：求解trace(inv(X))
power_he=sum(P);
minimize power_he

subject to
power_he <= station.powertotal/1e3
for i_P=1:station.num
    P(i_P,1) <= 0.5*station.powertotal/1e3
    P(i_P,1) >= 0.00005*station.powertotal/1e3
end

CRLB<=1.2*3e3

cvx_end

%记录优化后结果
for i_station_num = 1:station.num
    Power(i_station_num)=P(i_station_num,1)*1e3;
end

station.powerallocation(:,i_frame) = Power;
station.FIM(:,:,i_frame) = JK;
station.power_he_total(:,i_frame) = power_he*1e3;

end
