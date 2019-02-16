% Execute the whole process
clear; clc; close all;

% set parameters
func_names = {'1-Sphere', '2-Ellipsoidal', '3-BentCigar', '4-Discus', '5-DiffPowers', ...
    '6-Rosenbrock', '7-SchafferF7', '8-Ackley', '9-Weierstrass', '10-Griewank', ...
    '11-Rastrigin', '12-Schwefel', '13-Katsuura'
    };

dims = [2, 10, 30, 50];

for func_num = 1:13
    func_name = func_names{func_num};
    
    for d = 3
        dim = dims(d);
        
        % read the data of F-Race procedure
        read_F_file = ['result_race', filesep, 'F', filesep, 'dim_', num2str(dim), filesep, func_name, filesep, 'OpLeftNum.csv'];
        F_race_data = csvread(read_F_file);
        
        % read the data of KW-Race procedure
        read_KW_file = ['result_race', filesep, 'KW', filesep, 'dim_', num2str(dim), filesep, func_name, filesep, 'OpLeftNum.csv'];
        KW_race_data = csvread(read_KW_file);
        
        % plot procedure of  KW-Race VS. F-Race
        figure('Visible', 'off');
        p1 = plot(F_race_data, 'b--x', 'markersize', 5);
        hold on;
        p2 = plot(KW_race_data, 'g-^', 'markersize', 3);
        legend([p1, p2], 'F-Race', 'KW-Race', 'Location', 'best');
        legend('boxoff');
        xlabel('Restarts');
        ylabel('Left Parameter Configurations');
        title( 'KW-Race VS. F-Race');
        grid on;
        
        % init a folder to save results
        savepath =  ['result_race', filesep, 'KW_vs_F', filesep, 'dim_', num2str(dim), filesep, func_name];
        if ~isdir(savepath)
            mkdir(savepath);
        end
        
        print([savepath, filesep, 'KW_vs_F'], '-depsc', '-r1200');
        close;
        
    end
end