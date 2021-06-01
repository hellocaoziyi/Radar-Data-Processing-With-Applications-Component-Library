clear;
w = 1000;
distance = 1000:1000:40000;
P = (w*26000^2*0.03^2*100)./((4*pi)^3.*((distance).^4));
N = 4*10^-15;
SNR = P./N;
rho = (3*10^8*1*10^-3/(2*sqrt(2))).*(1./(SNR.^0.5));
hold on;
box on;
grid on;
plot(distance,rho,'Color','#0072BD','LineWidth',2,'DisplayName','距离噪声'); 
legend();
ylabel('距离噪声标准差/m','FontSize',20); 
xlabel('目标距离/m','FontSize',20);