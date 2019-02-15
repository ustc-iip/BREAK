clc; clear all;
for i = 1:4
    for D = [2, 10, 30, 50]
        load(['hybrid_func', num2str(i), '_M_D', num2str(D), '.mat']);
        for j = 1:10
            eval(['MM{j} = M.M', num2str(j)]);
        end
        M = MM;
        save(['hybrid_func', num2str(i), '_M_D', num2str(D), '.mat'], 'M');
    end
end