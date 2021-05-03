function target = constantVelocity(target)
%CONSTANTVELOCITY 雷达数据处理及应用器件库-系统模型-状态方程-匀速模型。
%INPUTS:    X0：初始状态，应该是一个四维向量，[x(km),vx(km/s),y(km),vy(km/s)]'。
%           k：采样次数。
%           dt：采样间隔(s)。
%           q：过程噪声协方差,是一个二维矩阵,[q1 0;0 q2]。
%OUTPUTS:   X：运动轨迹，是一个4*k的矩阵。
%           Q：CV模型过程噪声协方差矩阵。
target.F = [1 target.dt 0 0;0 1 0 0;0 0 1 target.dt;0 0 0 1];
target.GAMMA = [0.5*target.dt^2 0;target.dt 0;0 0.5*target.dt^2;0 target.dt];
target.X = zeros(4,target.frame);
target.Q = target.GAMMA*target.q*target.GAMMA';
delta = chol(target.q);
target.X(:,1) = target.X0;
for ni = 2:target.frame
    target.X(:,ni) = target.F*target.X(:,ni-1)+ target.GAMMA*(randn(1,2)*delta)';
end
end