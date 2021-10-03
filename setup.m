[~,username] = system('echo %USERNAME%');
username = strip(username);
pathname = ['C:\Users\',username,'\Documents\GitHub\'];
save('pathname.mat','pathname');