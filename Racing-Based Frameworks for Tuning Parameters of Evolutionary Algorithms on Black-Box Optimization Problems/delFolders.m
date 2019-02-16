% Execute the whole process
clear; clc; close all;

% set parameters
% func_names = {'1-Sphere', '2-Schwefel-102', '3-Rotated-Elliptic-High-Conditioned', '4-Schwefel-102-Noise', '5-Schwefel-206-OnBounds',...
%     '6-Rosenbrock', '7-Rotated-Griewank-WithoutBounds', '8-Rotated-Ackley-OnBounds', '9-Rastrigin', '10-Rotated-Rastrign',...
%     '11-Rotated-Weierstrass', '12-Schwefel-213', '13-Expanded-F8F2', '14-Expanded-ScafferF6', '15-Hybrid-Comp1',...
%     '16-Rotated-Hybrid-Comp1', '17-Rotated-Hybrid-Comp1-Noise', '18-Rotated-Hybrid-Comp2', '19-Rotated-Hybrid-Comp2-NarrowBasin', '20-Rotated-Hybrid-Comp2-OnBounds', ...
%     '21-Rotated-Hybrid-Comp3', '22-Rotated-Hybrid-Comp3-High-Conditioned', '23-Rotated-Hybrid-Comp3-NoContinuous', '24-Rotated-Hybrid-Comp4', '25-Rotated-Hybrid-Comp4-WithoutBounds'
%     };
func_names = {'1-Sphere', '2-Ellipsoidal', '3-Discus', '4-BentCigar', '5-DiffPowers', ...
    '6-Rosenbrock', '7-SchafferF7', '8-Ackley', '9-Weierstrass', '10-Griewank', ...
    '11-Rastrigin', '12-Schwefel', '13-Katsuura',  '14-Radar'
    };
algo_names = {'DE'};
dims = [2, 10, 30, 50];

mutationTypes = {'rand_1', 'best_1', 'target-to-best_1',  'best_2', 'rand_2', 'rand_2_dir'};
crossoverTypes = {'bin', 'exp'};
F = linspace(0.1, 0.9, 5);  % F is in the range (0, 1], F = {0.1, 0.3, 0.5, 0.7, 0.9}
CR = linspace(0.1, 0.9, 5);  % CR is in the range (0, 1), CR = {0.1, 0.3, 0.5, 0.7, 0.9}

runStart = 1;
runEnd = 50;

% delete folders
for dim = 3
    for func_num = 1
        for algo_num = 1
            algo_name = algo_names{algo_num};
            
            % set population size (default is 100) and other params
            % test different operators' combination
            n_ops = length(mutationTypes) * length(crossoverTypes) * ...
                length(F) * length(CR);
            for opIdx = 3:135
                % get the index of different operators
                [m, c, f, cr] = opIdx2compon(opIdx);
                
                MutationType = mutationTypes{m};
                CrossoverType = crossoverTypes{c};
                F_g = F(f);
                CR_g = CR(cr);
                
                for run_num = runStart:runEnd
                    saveRawPath = ['result', filesep, 'raw_data', filesep, 'dim_', num2str(dims(dim)),...
                        filesep, func_names{func_num}, filesep, algo_name, filesep, ...
                        [num2str(opIdx), '-', MutationType, '-', CrossoverType, '-F', ...
                        num2str(F_g), '-CR', num2str(CR_g)], filesep, ...
                        'run_', num2str(run_num)];
                    rmdir(saveRawPath, 's');
                end
            end
        end
    end
end

