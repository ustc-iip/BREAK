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
        
        % read the data of KW-Race procedure
        read_KW_file = ['result_race', filesep, 'KW', filesep, 'dim_', num2str(dim), filesep, func_name, filesep, 'OpLeftNum.csv'];
        KW_race_data = csvread(read_KW_file);
        
        % read the data of F-KW-Race procedure
        read_F_KW_file = ['result_race', filesep, 'F-KW', filesep, 'dim_', num2str(dim), filesep, func_name, filesep, 'OpLeftNum.csv'];
        F_KW_race_data = csvread(read_F_KW_file);
        
        % plot procedure of  KW-Race VS. F-Race
        figure('Visible', 'off');
        p1 = plot(KW_race_data, 'b--x', 'markersize', 5);
        hold on;
        p2 = plot(F_KW_race_data, 'g-^', 'markersize', 3);
        legend([p1, p2], 'KW-Race', 'F-KW-Race', 'Location', 'best');
        legend('boxoff');
        xlabel('Restarts');
        ylabel('Left Parameter Configurations');
        title( 'F-KW-Race VS. KW-Race');
        grid on;
        
        % init a folder to save results
        savepath =  ['result_race', filesep, 'F-KW_vs_KW', filesep, 'dim_', num2str(dim), filesep, func_name];
        if ~isdir(savepath)
            mkdir(savepath);
        end
        
        print([savepath, filesep, 'F-KW_vs_KW'], '-depsc', '-r1200');
        close;
        
    end
end