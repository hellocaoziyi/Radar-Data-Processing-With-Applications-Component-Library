for i_exp = 1:7
    exp_name = strcat('exp',num2str(i_exp),'.m');
    fprintf('开始运行exp%d\n', i_exp);
    run(exp_name);
    clearvars -except i_exp nMonte;
    close all;
    fprintf('exp%d运行完成\n', i_exp);
end
fprintf('exp1到exp%d已经全部运行完成\n', i_exp);