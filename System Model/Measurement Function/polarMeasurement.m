function [Zpol,Zcart] = polarMeasurement(targets,k,R,origin)
%POLARMEASUREMENT 雷达数据处理及应用器件库-系统模型-量测方程-极坐标量测模型
%INPUTS：targets：目标运动轨迹
%        k：仿真步数
%        R：量测协方差
%        origin：测量点直角坐标（可选，默认为原点）
%OUTPUTS：Zpol：量测轨迹（极坐标）
%         Zcart：量测轨迹（直角坐标）
if nargin==3
    H = [1 0 0 0;0 0 1 0];
    Zcart = zeros(2,k);
    Zpol = zeros(2,k);
    delta = chol(R);
    for ni = 1:k
        Zcart(:,ni) = H*targets(:,ni);
        Zpol(:,ni) = cartesian2Polar(Zcart(1,ni),Zcart(2,ni)) + (randn(1,2)*delta)';
    end
elseif nargin==4
    H = [1 0 0 0;0 0 1 0];
    Zcart = zeros(2,k);
    Zpol = zeros(2,k);
    delta = chol(R);
    for ni = 1:k
        Zcart(:,ni) = H*targets(:,ni)-origin;
        Zpol(:,ni) = cartesian2Polar(Zcart(1,ni),Zcart(2,ni)) + (randn(1,2)*delta)';
        Zcart(:,ni) = polar2Cartesian(Zpol(1,ni),Zpol(2,ni)) + origin;
        if ni > 1
            if Zpol(1,ni-1) > 0
                modZpol = mod(Zpol(1,ni-1),2*pi);
                if modZpol > pi
                    modZpol2 = modZpol - 2*pi;
                    if (Zpol(1,ni) - modZpol2) > pi
                        Zpol(1,ni) = Zpol(1,ni-1) - (modZpol - Zpol(1,ni));
                    elseif Zpol(1,ni) < modZpol2
                        Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
                    else
                        Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
                    end
                else
                    modZpol2 = modZpol;
                    if (modZpol2 - Zpol(1,ni)) > pi
                        Zpol(1,ni) = Zpol(1,ni-1) + (2*pi - modZpol + Zpol(1,ni));
                    elseif Zpol(:,ni) < modZpol2
                        Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
                    else
                        Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
                    end
                end
            elseif Zpol(1,ni-1) < 0
                modZpol = mod(Zpol(1,ni-1),-2*pi);
                if modZpol < -pi
                    modZpol2 = modZpol + 2*pi;
                     if (modZpol2 - Zpol(1,ni)) > pi
                        Zpol(1,ni) = Zpol(1,ni-1) + (2*pi - modZpol2 + Zpol(1,ni));
                    elseif Zpol(:,ni) < modZpol2
                        Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
                    else
                        Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
                    end
                else
                    modZpol2 = modZpol;
                    if (Zpol(1,ni) - modZpol2) > pi
                        Zpol(1,ni) = Zpol(1,ni-1) - (2*pi + modZpol2 - Zpol(1,ni));
                    elseif Zpol(:,ni) > modZpol2
                        Zpol(1,ni) = Zpol(1,ni-1) + (Zpol(1,ni) - modZpol2);
                    else
                        Zpol(1,ni) = Zpol(1,ni-1) - (modZpol2 - Zpol(1,ni));
                    end
                end
            else
                modZpol = 0;
                modZpol2 = modZpol;
                Zpol(1,ni) = Zpol(1,ni) + Zpol(1,ni-1) + modZpol2;
            end
        end
    end
end
end