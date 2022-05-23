function Target = falseMeasurement(Target,Station)
%FALSEMEASUREMENT 此处显示有关此函数的摘要
%   此处显示详细说明
for iITer = 1:Target.nIter
    for targetnum = 1:Target.num
        if targetnum == 1
            %初始化
            %单位面积虚假量测数
            lamda = 0.0004;
            %正方形面积
            false_measurement_area = 10.*Station.gatearea;
            %产生虚假点数
            nc = zeros(Target.num,Target.nIter);
            nc(targetnum,iITer) = floor(false_measurement_area(targetnum,iITer) .* lamda);
        else
            %产生虚假点数
            nc(targetnum,iITer) = floor(false_measurement_area(targetnum,iITer) .* lamda);
        end
    end
end
nc_max = max(nc,[],'all');
Station.flasemeasurement = zeros(2,nc_max,Target.num,Target.nIter);
for iITer = 1:Target.nIter
    for targetnum = 1:Target.num
        %以真实点作为正方形中心
        center_x = Target.X(1,targetnum,iITer);
        center_y = Target.X(3,targetnum,iITer);
        %划定正方形边界
        q = sqrt(false_measurement_area(targetnum,iITer))/2;
        bound_left = center_x - q;
        bound_bottom = center_y - q;
        if nc(targetnum,iITer) == 0
            Station.flasemeasurement(:,1,targetnum,iITer) = [NaN NaN];
        else
            for ni = 1:nc(targetnum,iITer)
                Station.flasemeasurement(1,ni,targetnum,iITer) = bound_left + (2*q*rand);
                Station.flasemeasurement(2,ni,targetnum,iITer) = bound_bottom + (2*q*rand);
            end
            Station.flasemeasurement(:,ni+1,targetnum,iITer) = [NaN NaN];
        end
    end
end
end
