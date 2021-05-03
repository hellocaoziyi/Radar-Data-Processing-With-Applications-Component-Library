function station = polarMeasurement(target,station)
%POLARMEASUREMENT 雷达数据处理及应用器件库-系统模型-量测方程-极坐标量测模型
%INPUTS：targets：目标运动轨迹
%        R：量测协方差
%        origin：测量点直角坐标（可选，默认为原点）
%OUTPUTS：Zpol：量测轨迹（极坐标）
%         Zcart：量测轨迹（直角坐标）
frame = target.frame;
origin_total = station.num;
station.H = [1 0 0 0;0 0 1 0];
H = station.H;
R = station.Rpol;
targets = target.X;
origin = station.origin;
Zcart = zeros(2,frame,origin_total);
Zpol = zeros(2,frame,origin_total);
if nargin==1
    for origin_num = 1:origin_total      
        delta = chol(R(:,:,origin_num));
        for ni = 1:frame
            Zcart(:,ni,origin_num) = H*targets(:,ni);
            Zpol(:,ni,origin_num) = cartesian2Polar(Zcart(1,ni,origin_num),Zcart(2,ni,origin_num)) + (randn(1,2)*delta)';
        end
    end
elseif nargin==2
    for origin_num = 1:origin_total
        delta = chol(R(:,:,origin_num));
        for ni = 1:frame
            Zcart(:,ni,origin_num) = H*targets(:,ni)-origin(:,origin_num);
            Zpol(:,ni,origin_num) = cartesian2Polar(Zcart(1,ni,origin_num),Zcart(2,ni,origin_num)) + (randn(1,2)*delta)';
            Zcart(:,ni,origin_num) = polar2Cartesian(Zpol(1,ni,origin_num),Zpol(2,ni,origin_num)) + origin(:,origin_num);
            if ni > 1
                if Zpol(1,ni-1,origin_num) > 0
                    modZpol = mod(Zpol(1,ni-1,origin_num),2*pi);
                    if modZpol > pi
                        modZpol2 = modZpol - 2*pi;
                        if (Zpol(1,ni,origin_num) - modZpol(2,origin_num)) > pi
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (modZpol - Zpol(1,ni,origin_num));
                        elseif Zpol(1,ni,origin_num) < modZpol2
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (modZpol2 - Zpol(1,ni,origin_num));
                        else
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (Zpol(1,ni,origin_num) - modZpol2);
                        end
                    else
                        modZpol2 = modZpol;
                        if (modZpol2 - Zpol(1,ni,origin_num)) > pi
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (2*pi - modZpol + Zpol(1,ni,origin_num));
                        elseif Zpol(:,ni,origin_num) < modZpol2
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (modZpol2 - Zpol(1,ni,origin_num));
                        else
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (Zpol(1,ni,origin_num) - modZpol2);
                        end
                    end
                elseif Zpol(1,ni-1,origin_num) < 0
                    modZpol = mod(Zpol(1,ni-1,origin_num),-2*pi);
                    if modZpol < -pi
                        modZpol2 = modZpol + 2*pi;
                        if (modZpol2 - Zpol(1,ni,origin_num)) > pi
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (2*pi - modZpol2 + Zpol(1,ni,origin_num));
                        elseif Zpol(:,ni,origin_num) < modZpol2
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (modZpol2 - Zpol(1,ni,origin_num));
                        else
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (Zpol(1,ni,origin_num) - modZpol2);
                        end
                    else
                        modZpol2 = modZpol;
                        if (Zpol(1,ni,origin_num) - modZpol2) > pi
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (2*pi + modZpol2 - Zpol(1,ni,origin_num));
                        elseif Zpol(:,ni,origin_num) > modZpol2
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) + (Zpol(1,ni,origin_num) - modZpol2);
                        else
                            Zpol(1,ni,origin_num) = Zpol(1,ni-1,origin_num) - (modZpol2 - Zpol(1,ni,origin_num));
                        end
                    end
                else
                    modZpol = 0;
                    modZpol2 = modZpol;
                    Zpol(1,ni,origin_num) = Zpol(1,ni,origin_num) + Zpol(1,ni-1,origin_num) + modZpol2;
                end
            end
        end
    end
end
station.Zpol = Zpol;
station.Zcart = Zcart;
end