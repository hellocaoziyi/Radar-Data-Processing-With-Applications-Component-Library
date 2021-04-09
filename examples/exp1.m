clear;
close all;

for monte = 1:50

X1_0 = [1000 170 8000 -120]';
q1 = [5^2 0;0 5^2];

k = 50;
T = 1;

[X1,Q] = constantVelocity(X1_0,k,T,q1);

storageName = strcat('exp1_',num2str(monte),'.mat');
save(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp1\',storageName],'X1','Q','k','T');

end

hold on;
plot(X1(1,:),X1(3,:),'LineWidth',2,'DisplayName','目标运动轨迹');
legend();
title('运动轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);