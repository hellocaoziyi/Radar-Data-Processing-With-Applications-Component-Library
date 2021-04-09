clear;
close all;

for monte = 1:50
    
storageName = strcat('exp1_',num2str(monte),'.mat');
load(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp1\',storageName]);

origin1 = [1500 5500]';
origin2 = [4000 4000]';
origin3 = [6000 3000]';

Rpol1 = [0.04^2 0;0 60^2];
Rpol2 = [0.05^2 0;0 100^2];
Rpol3 = [0.09^2 0;0 150^2];

[Zpol1_1,Zcart1_1] = polarMeasurement(X1,Rpol1,origin1);
[Zpol1_2,Zcart1_2] = polarMeasurement(X1,Rpol2,origin2);
[Zpol1_3,Zcart1_3] = polarMeasurement(X1,Rpol3,origin3);

storageName = strcat('exp2_',num2str(monte),'.mat');
save(['C:\workdir\Project\undergraduate\毕业设计\仿真实验\data\exp2\',storageName],'X1','Q','k','T',...
    'origin1','origin2','origin3','Rpol1','Rpol2','Rpol3',...
    'Zpol1_1','Zpol1_2','Zpol1_3','Zcart1_1','Zcart1_2','Zcart1_3');

end

hold on;
plot(X1(1,:),X1(3,:),'k','LineWidth',2,'DisplayName','真实轨迹');
scatter(origin1(1,1),origin1(2,1),'b','LineWidth',2,'DisplayName','雷达1 量测点');
scatter(origin2(1,1),origin2(2,1),'rs','LineWidth',2,'DisplayName','雷达2 量测点');
scatter(origin3(1,1),origin3(2,1),'cd','LineWidth',2,'DisplayName','雷达3 量测点');
plot(Zcart1_1(1,:),Zcart1_1(2,:),'b:','LineWidth',2,'DisplayName','雷达1量测轨迹');
plot(Zcart1_2(1,:),Zcart1_2(2,:),'r--','LineWidth',2,'DisplayName','雷达2量测轨迹');
plot(Zcart1_3(1,:),Zcart1_3(2,:),'c-.','LineWidth',2,'DisplayName','雷达3量测轨迹');
title('运动轨迹和量测轨迹','FontSize',20);
xlabel('x/m','FontSize',20); 
ylabel('y/m','FontSize',20); 
legend();