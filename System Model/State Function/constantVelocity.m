function Target = constantVelocity(Target)
%CONSTANTVELOCITY 雷达数据处理及应用器件库-系统模型-状态方程-匀速模型。
%INPUTS:    Target.state0：初始状态，应该是一个四维向量，[x(km),vx(km/s),y(km),vy(km/s)]'。
%           Target.nIter：采样次数。
%           Target.dt：采样间隔(s)。
%           Target.q：过程噪声标准差,是一个二维矩阵,[q1 0;0 q2]。
%OUTPUTS:   Target.X：运动状态，是一个4*k的矩阵。
%           Target.Q：CV模型过程噪声协方差矩阵。
%           Target.F：状态转换矩阵
for targetnum = 1:Target.num
    if targetnum == 1
        Target.F = [1 Target.dt 0 0;0 1 0 0;0 0 1 Target.dt;0 0 0 1];
        Target.GAMMA = [0.5*Target.dt^2 0;Target.dt 0;0 0.5*Target.dt^2;0 Target.dt];
        Target.X = zeros(4,Target.num,Target.nIter);
        Target.Q = zeros(4,4,Target.num,Target.nIter);
        Target.Q(:,:,targetnum,1) = Target.GAMMA*Target.q(:,:,targetnum)*Target.GAMMA';
        delta = chol(Target.q(:,:,targetnum));
        Target.X(:,targetnum,1) = Target.X0(:,targetnum);
    else
        Target.Q(:,:,targetnum,1) = Target.GAMMA*Target.q(:,:,targetnum)*Target.GAMMA';
        delta(:,:,targetnum) = chol(Target.q(:,:,targetnum));
        Target.X(:,targetnum,1) = Target.X0(:,targetnum);
    end
    for iIter = 2:Target.nIter
        Target.Q(:,:,targetnum,iIter) = Target.GAMMA*Target.q(:,:,targetnum)*Target.GAMMA';
        Target.X(:,targetnum,iIter) = Target.F*Target.X(:,targetnum,iIter-1)+ Target.GAMMA*(randn(1,2)*delta(:,:,targetnum))';
    end
end
end