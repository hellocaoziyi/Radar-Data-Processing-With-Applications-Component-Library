function Station = measurementNoise(Target,Station,iIter)
%MEASUREMENTNOISE 此处显示有关此函数的摘要
%   此处显示详细说明
for iStation = 1:Station.nStation
    distance = sqrt((Station.address(1,iStation)-Target.X(1,iIter))^2+(Station.address(2,iStation)-Target.X(3,iIter))^2);
%     alpha=1/(((1e3*distance)^2)^2)*Station.C^2*1500;
    alpha=4*pi*Station.FREQUENCY^2/(4*pi*distance^2)^2;
    
    sigma2_x=Station.C^2/(8*pi^2*alpha*Station.powerallocation(iStation,iIter)*(abs(Station.rcs(iStation,iIter)))^2*Station.BANDWIDTH(iStation)^2);
    sigma2_y=Station.C^2/(8*pi^2*alpha*Station.powerallocation(iStation,iIter)*(abs(Station.rcs(iStation,iIter)))^2*Station.BANDWIDTH(iStation)^2);
    
    Station.R(:,:,iIter,iStation) = diag([sigma2_x,sigma2_y]);
end
end