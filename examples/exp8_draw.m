clearvars -except i_exp;
close all;
load('pathname.mat');

load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp8\exp8_uniform.mat']);
load([pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp8\exp8_optimal.mat']);

exp8_1=figure('Name','exp8_draw');
hold on;
box on;
grid on;
plot(PCRB_optimal,'Color','#0072BD','LineWidth',2,'DisplayName','优化功率分配PCRLB');
plot(PCRB_uniform,'Color','#D95319','LineWidth',2,'DisplayName','平均功率分配PCRLB');
plot(Xci_optimal,'Color','#0072BD','LineStyle',':','LineWidth',2,'DisplayName','优化功率分配RMSE');
plot(Xci_uniform,'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','平均功率分配RMSE');
xlabel('时刻/s','FontSize',20);
ylabel('误差/m','FontSize',20);
legend();
exportgraphics(exp8_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_1.emf'],'Resolution',600);
exportgraphics(exp8_1,[pathname,'Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp8_1.jpg'],'Resolution',600);
