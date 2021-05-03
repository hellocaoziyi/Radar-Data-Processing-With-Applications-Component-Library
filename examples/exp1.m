clearvars -except exp_ni;
close all;

target.X0 = [1000 170 8000 -120]';
target.q = [5^2 0;0 5^2];

target.frame = 50;
target.dt = 1;

target = constantVelocity(target);

for monte = 1:50

storageName = strcat('exp1_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName],'target');

end

exp1_1 = figure('Name','exp1_1');
hold on;
plot(target.X(1,:),target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
legend();
title('运动轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.emf','Resolution',600);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.jpg','Resolution',600);