for exp_ni = 1:7
    exp_name = strcat('exp',num2str(exp_ni),'.m');
    fprintf('开始运行exp%d\n', exp_ni);
    run(exp_name);
    clearvars -except exp_ni;
    close all;
    fprintf('exp%d运行完成\n', exp_ni);
end
fprintf('exp1到exp%d已经全部运行完成\n', exp_ni);