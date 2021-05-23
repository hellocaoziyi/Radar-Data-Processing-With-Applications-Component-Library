clearvars -except i_exp nMonte;
close all;

for iMonte = 1:nMonte
    
    storageName = strcat('exp2_',num2str(iMonte),'.mat');
    load(['C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\data\exp2\',storageName]);
    
    if iMonte == 1
        Zx_monte = zeros(Target.nIter,Station.nStation);
        Zy_monte = zeros(Target.nIter,Station.nStation);
    end
    for jStation = 1:Station.nStation
        Zx_monte(:,jStation) = Zx_monte(:,jStation)' + (Target.X(1,:) - Station.Zcart(1,:,jStation)).^2 ;
        Zy_monte(:,jStation) = Zy_monte(:,jStation)' + (Target.X(3,:) - Station.Zcart(2,:,jStation)).^2 ;
    end
    
end

for iStation = 1:Station.nStation
    Zx_monte(:,iStation) = (Zx_monte(:,iStation)./nMonte).^0.5;
    Zy_monte(:,iStation) = (Zy_monte(:,iStation)./nMonte).^0.5;
end

exp2_2 = figure('Name','exp2_2');
hold on;
box on;
grid on;
plot(Zx_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测误差');
plot(Zx_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2量测误差');
plot(Zx_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3量测误差');
% title('雷达x方向量测误差','FontSize',20);
xlabel('时间/s','FontSize',20);
ylabel('均方根误差/m','FontSize',20);
legend();
exportgraphics(exp2_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_2.emf','Resolution',600);
exportgraphics(exp2_2,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_2.jpg','Resolution',600);

exp2_3 = figure('Name','exp2_3');
hold on;
box on;
grid on;
plot(Zy_monte(:,1),'Color','#D95319','LineStyle',':','LineWidth',2,'DisplayName','雷达1量测误差');
plot(Zy_monte(:,2),'Color','#EDB120','LineStyle','--','LineWidth',2,'DisplayName','雷达2量测误差');
plot(Zy_monte(:,3),'Color','#7E2F8E','LineStyle','-.','LineWidth',2,'DisplayName','雷达3量测误差');
% title('雷达y方向量测误差','FontSize',20);
xlabel('时间/s','FontSize',20);
ylabel('均方根误差/m','FontSize',20);
legend();
exportgraphics(exp2_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_3.emf','Resolution',600);
exportgraphics(exp2_3,'C:\Users\nick\Documents\GitHub\Radar-Data-Processing-With-Applications-Component-Library\examples\pic\exp2_3.jpg','Resolution',600);
