clearvars -except i_exp;
close all;

load('pathname.mat');
nMonte = 50;

Target.X0 = [1000 9000
            170  -170
            8000 8000
            -120 -120];
Target.q = [1^2 0;0 1^2];
Target.q(:,:,2) = [1^2 0;0 1^2];
Target.nIter = 50;
Target.dt = 1;
Target.num = size(Target.q,2);
for iMonte = 1:nMonte

Target = constantVelocity(Target);

storageName = strcat('exp1_',num2str(iMonte),'.mat');
save([pathname,'\Multiple Target Tracking\examples\data\exp1\',storageName],'Target','nMonte');

end

exp1_1 = figure('Name','exp1_1');
exp1_1.Visible = 'off';
hold on;
for targetnum = 1:Target.num
plot(squeeze(Target.X(1,targetnum,:)),squeeze(Target.X(3,targetnum,:)),'Color',defaultPlotColors(targetnum),'LineWidth',2,'DisplayName','目标运动轨迹');
end
legend();
title('运动轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20);
exportgraphics(exp1_1,[pathname,'\Multiple Target Tracking\examples\pic\exp1_1.emf'],'Resolution',600);
exportgraphics(exp1_1,[pathname,'\Multiple Target Tracking\examples\pic\exp1_1.jpg'],'Resolution',600);
exp1_1.Visible = 'on';