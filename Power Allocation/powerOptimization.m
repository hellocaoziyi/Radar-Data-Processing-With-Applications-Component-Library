function Station = powerOptimization(Target,Station,iIter)
%POWEROPTIMIZATION 此处显示有关此函数的摘要
%   此处显示详细说明

%先求解黑塞矩阵
H = zeros(4,2,Station.nStation);
for iStation = 1:Station.nStation
    H(:,1,iStation)=[1;Target.dt;0;0];
    H(:,2,iStation)=[0;0;1;Target.dt];
end

%优化参数
Jp=inv(Target.Q(:,:,iIter)+Target.F*inv(Station.FIM(:,:,iIter-1))*Target.F');

%功率分配
cvx_begin quiet

variable P(Station.nStation,1)

for iStation = 1:Station.nStation
    
    distance = sqrt((Station.address(1,iStation)-Target.X(1,iIter))^2+(Station.address(2,iStation)-Target.X(3,iIter))^2);
    Pr(iStation,iIter) = (26000^2*0.03^2*100)/((4*pi)^3*distance^4);
    SNR = Pr(iStation,iIter)/(4e-15);
    sigma_rho_inv = sqrt(8*SNR)/3e5;
    measurement_cov_inv_opt(:,:,iStation)=diag([sigma_rho_inv,sigma_rho_inv]).* (P(iStation,1)).^0.5; 
%     distance = sqrt((Station.address(1,iStation)-Target.X(1,iIter))^2+(Station.address(2,iStation)-Target.X(3,iIter))^2);
%     alpha_opt = 1/(((1e3*distance)^2)^2)*Station.C^2*1500;
%     
%     sigma2_x_opt=Station.C^2/(8*pi^2*alpha_opt*(abs(Station.rcs(iStation)))^2*Station.BANDWIDTH(iStation)^2);
%     sigma2_y_opt=Station.C^2/(8*pi^2*alpha_opt*(abs(Station.rcs(iStation)))^2*Station.BANDWIDTH(iStation)^2);
%     
%     measurement_cov_inv_opt(:,:,iStation)=diag([1/sigma2_x_opt,1/sigma2_y_opt]).*1e3.* P(iStation,1);  %优化功率
%     
    JD_opt(:,:,iStation)=H(:,:,iStation)*measurement_cov_inv_opt(:,:,iStation)*H(:,:,iStation)';
    
end

JD_sum=sum(JD_opt,3);
JK=Jp+JD_sum;

CRLB=trace(JK);                    % CVX里面的写法：求解trace(inv(X))
power_he=sum(P);
% minimize power_he
% minimize CRLB
maximize CRLB

subject to
power_he == Station.POWERTOTAL
for i_P=1:Station.nStation
    P(i_P,1) <= 0.6*Station.POWERTOTAL
    P(i_P,1) >= 0.1*Station.POWERTOTAL
end

% CRLB <= Station.PCRB(1)

cvx_end

%记录优化后结果
for iStation = 1:Station.nStation
    Power(iStation)=P(iStation,1);
end

Station.powerallocation(:,iIter) = Power;

end
