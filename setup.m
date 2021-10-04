% [~,username] = system('echo %USERNAME%');
% username = strip(username);
% pathname = ['C:\Users\',username,'\Documents\GitHub\'];
% save('pathname.mat','pathname');

pathname = mfilename('fullpath');
[pathname,~] = fileparts(pathname);
pathname = strip(pathname);
save('pathname.mat','pathname');