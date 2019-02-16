% Execute the whole process
clear; clc; close all;

func_names = {'1-Sphere', '2-Ellipsoidal', '3-BentCigar', '4-Discus', '5-DiffPowers', ...
    '6-Rosenbrock', '7-SchafferF7', '8-Ackley', '9-Weierstrass', '10-Griewank', ...
    '11-Rastrigin', '12-Schwefel', '13-Katsuura'
    };
dims = [2, 10, 30, 50];
race_names = {'F', 'KW', 'F-KW'};

accuracy = zeros(1, 13);

for race_num = 1:3
    for d = 3
        dim = dims(d);
        
        for func_num = 1:13
            [lb, ub] = get_lb_ub(func_num);

            
            loadpath = ['result_race', filesep, race_names{race_num}, filesep, 'dim_', num2str(dim), filesep, func_names{func_num}];
            load([loadpath, filesep, 'bestOpId_fit.csv']);
            B = bestOpId_fit;
            
            load([loadpath, filesep, 'OpLeft.csv']);
            A = OpLeft(size(OpLeft, 1), :);
            id = ismember(A, B);
            accuracy(func_num) = sum(id) / sum(A>0);
        end
    end
    
    csvwrite( ['result_race', filesep, race_names{race_num}, filesep, 'accuracy_restart_40.csv'], accuracy);
end