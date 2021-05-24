function Station = polarMeasurement(Target,Station)
%POLARMEASUREMENT 雷达数据处理及应用器件库-系统模型-量测方程-极坐标量测模型
%INPUTS：Target.X：目标运动轨迹
%        Station.Rpol：量测协方差
%        Station.address：测量点直角坐标（可选，默认为原点）
%OUTPUTS：Station.Zpol：量测轨迹（极坐标）
%         Station.Zcart：量测轨迹（直角坐 标）
Station.H = [1 0 0 0;0 0 1 0];
Station.Zcart = zeros(2,Target.nIter,Station.nStation);
Station.Zpol = zeros(2,Target.nIter,Station.nStation);
for iStation = 1:Station.nStation
    delta = chol(Station.Rpol(:,:,iStation));
    for jIter = 1:Target.nIter
        Station.Zcart(:,jIter,iStation) = Station.H*Target.X(:,jIter)-Station.address(:,iStation);
        Station.Zpol(:,jIter,iStation) = cartesian2Polar(Station.Zcart(1,jIter,iStation),Station.Zcart(2,jIter,iStation)) + (randn(1,2)*delta)';
        Station.Zcart(:,jIter,iStation) = polar2Cartesian(Station.Zpol(1,jIter,iStation),Station.Zpol(2,jIter,iStation)) + Station.address(:,iStation);
        if jIter > 1
            if Station.Zpol(1,jIter-1,iStation) > 0
                modZpol = mod(Station.Zpol(1,jIter-1,iStation),2*pi);
                if modZpol > pi
                    modZpol2 = modZpol - 2*pi;
                if (Station.Zpol(1,jIter,iStation) - modZpol) > pi
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (modZpol - Station.Zpol(1,jIter,iStation));
                    elseif Station.Zpol(1,jIter,iStation) < modZpol2
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (modZpol2 - Station.Zpol(1,jIter,iStation));
                    else
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (Station.Zpol(1,jIter,iStation) - modZpol2);
                    end
                else
                    modZpol2 = modZpol;
                    if (modZpol2 - Station.Zpol(1,jIter,iStation)) > pi
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (2*pi - modZpol + Station.Zpol(1,jIter,iStation));
                    elseif Station.Zpol(:,jIter,iStation) < modZpol2
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (modZpol2 - Station.Zpol(1,jIter,iStation));
                    else
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (Station.Zpol(1,jIter,iStation) - modZpol2);
                    end
                end
            elseif Station.Zpol(1,jIter-1,iStation) < 0
                modZpol = mod(Station.Zpol(1,jIter-1,iStation),-2*pi);
                if modZpol < -pi
                    modZpol2 = modZpol + 2*pi;
                    if (modZpol2 - Station.Zpol(1,jIter,iStation)) > pi
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (2*pi - modZpol2 + Station.Zpol(1,jIter,iStation));
                    elseif Station.Zpol(:,jIter,iStation) < modZpol2
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (modZpol2 - Station.Zpol(1,jIter,iStation));
                    else
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (Station.Zpol(1,jIter,iStation) - modZpol2);
                    end
                else
                    modZpol2 = modZpol;
                    if (Station.Zpol(1,jIter,iStation) - modZpol2) > pi
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (2*pi + modZpol2 - Station.Zpol(1,jIter,iStation));
                    elseif Station.Zpol(:,jIter,iStation) > modZpol2
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) + (Station.Zpol(1,jIter,iStation) - modZpol2);
                    else
                        Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter-1,iStation) - (modZpol2 - Station.Zpol(1,jIter,iStation));
                    end
                end
            else
                modZpol = 0;
                modZpol2 = modZpol;
                Station.Zpol(1,jIter,iStation) = Station.Zpol(1,jIter,iStation) + Station.Zpol(1,jIter-1,iStation) + modZpol2;
            end
        end
    end
end
end