function bestIndiPath(g_ind, saveIndiPath, func_num, file_name)
if ~isdir(saveIndiPath)
    mkdir(saveIndiPath);
end
f1= figure('Visible', 'off');
s1 = subplot(1,1,1);
plot(s1, g_ind(:,1), g_ind(:,2), 'MarkerSize', 10);
title(s1, file_name);
hold on;
load(['rand_shift_',num2str(func_num), '.mat']);
plot(s1, rand_shift(1), rand_shift(2), 'rp');
grid on;
print('-dtiff', '-r600', [saveIndiPath, filesep, file_name]);
close(f1);
end

