function station = measurementNoise(target,station,i_frame)
%MEASUREMENTNOISE 此处显示有关此函数的摘要
%   此处显示详细说明
for i_station_num = 1:station.num
    distance = sqrt(station.origin(1,i_station_num)-(target.X(1,i_frame))^2+(station.origin(2,i_station_num)-target.X(3,i_frame))^2);
    alpha=1/(((1e3*distance)^2)^2)*station.c^2*1500;
    
    sigma2_x=station.c^2/(8*pi^2*alpha*station.powerallocation(i_station_num,i_frame)*(abs(station.rcs(i_station_num,i_frame)))^2*station.bandwidth(i_station_num)^2);
    sigma2_y=station.c^2/(8*pi^2*alpha*station.powerallocation(i_station_num,i_frame)*(abs(station.rcs(i_station_num,i_frame)))^2*station.bandwidth(i_station_num)^2);
    
    station.R(:,:,i_frame,i_station_num) = diag([sigma2_x,sigma2_y]);
end
end