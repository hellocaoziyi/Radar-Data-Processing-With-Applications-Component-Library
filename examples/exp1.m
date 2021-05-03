clearvars -except exp_ni;
close all;



X1_0 = [1000 170 8000 -120]';
q1 = [5^2 0;0 5^2];

k = 50;
T = 1;

[X1,Q] = constantVelocity(X1_0,k,T,q1);

for monte = 1:50

storageName = strcat('exp1_',num2str(monte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName],'X1','Q','k','T');

end

exp1_1 = figure('Name','exp1_1');
hold on;
plot(X1(1,:),X1(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
legend();
title('运动轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.emf','Resolution',600);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.jpg','Resolution',600);