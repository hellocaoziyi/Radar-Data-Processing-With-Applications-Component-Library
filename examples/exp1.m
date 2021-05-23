clearvars -except i_exp nMonte;
close all;

nMonte = 50;

Target.X0 = [1000 170 8000 -120]';
Target.q = [5^2 0;0 5^2];
Target.nIter = 50;
Target.dt = 1;

for iMonte = 1:nMonte

Target = constantVelocity(Target);

storageName = strcat('exp1_',num2str(iMonte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName],'Target');

end

exp1_1 = figure('Name','exp1_1');
hold on;
box on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineWidth',2,'DisplayName','目标运动轨迹');
legend();
% title('运动轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.emf','Resolution',600);
exportgraphics(exp1_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp1_1.jpg','Resolution',600);