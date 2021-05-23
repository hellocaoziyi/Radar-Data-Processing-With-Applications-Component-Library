clearvars -except i_exp nMonte;
close all;

%每次使用相同运动轨迹
storageName = strcat('exp1_',num2str(nMonte),'.mat');
load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName]);

for imonte = 1:nMonte

%每次使用不同运动轨迹
% storageName = strcat('exp1_',num2str(monte),'.mat');
% load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp1\',storageName]);

Station.address = [1400 5300;3200 3500;5900 2300]';
Station.nStation = size(Station.address,2);

Rpol1 = [0.04^2 0;0 60^2];
Rpol2 = [0.05^2 0;0 100^2];
Rpol3 = [0.07^2 0;0 120^2];
Station.Rpol = cat(3,Rpol1,Rpol2,Rpol3);

Station = polarMeasurement(Target,Station);

storageName = strcat('exp2_',num2str(imonte),'.mat');
save(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp2\',storageName],...
    'Target',...
    'Station');

end

exp2_1 = figure('Name','exp2_1');
hold on;
box on;
plot(Target.X(1,:),Target.X(3,:),'Color','#0072BD','LineStyle','-','LineWidth',2,'DisplayName','目标运动轨迹');
scatter(Station.address(1,1),Station.address(2,1),'MarkerEdgeColor','#D95319','Marker','o','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(Station.address(1,2),Station.address(2,2),'MarkerEdgeColor','#EDB120','Marker','s','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(Station.address(1,3),Station.address(2,3),'MarkerEdgeColor','#7E2F8E','Marker','d','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Station.Zcart(1,:,1),Station.Zcart(2,:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Station.Zcart(1,:,2),Station.Zcart(2,:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2量测轨迹');
plot(Station.Zcart(1,:,3),Station.Zcart(2,:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3量测轨迹');
% title('运动轨迹和量测轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();
exportgraphics(exp2_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_1.emf','Resolution',600);
exportgraphics(exp2_1,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_1.jpg','Resolution',600);
