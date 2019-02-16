% Execute the whole process
clear; clc; close all;

% add benchmark path
addpath(genpath('benchmark_func_2013'));

% set parameters
func_names = {'1-Sphere', '2-Ellipsoidal', '3-BentCigar', '4-Discus', '5-DiffPowers', ...
    '6-Rosenbrock', '7-SchafferF7', '8-Ackley', '9-Weierstrass', '10-Griewank', ...
    '11-Rastrigin', '12-Schwefel', '13-Katsuura'
    };
algo_names = {'DE'};
dims = [2, 10, 30, 50];

mutationTypes = {'rand_1', 'best_1', 'target-to-best_1',  'best_2', 'rand_2', 'rand_2_dir'};
crossoverTypes = {'bin', 'exp'};
F = linspace(0.1, 0.9, 5);  % F is in the range (0, 1], F = {0.1, 0.3, 0.5, 0.7, 0.9}
CR = linspace(0.1, 0.9, 5);  % CR is in the range (0, 1), CR = {0.1, 0.3, 0.5, 0.7, 0.9}
NP= linspace(20, 180, 5);  % NP is in the range (0, 200), CR = {20, 60, 100, 140, 180}

runStart = 1;
runEnd = 40;

% performance evaluation
options = setOptions(); % init options
optionalArgs = struct();
for d = 3
    dim = dims(d);
    
    for func_num = 14
        [lb, ub] = get_lb_ub(func_num);
        
        % if want to change PopulationSize, set here
        for algo_num = 1
            algo_name = algo_names{algo_num};
            
            % set population size (default is 100) and other params
            % test different operators' combination
            n_ops = length(mutationTypes) * length(crossoverTypes) * ...
                length(F) * length(CR) * length(NP);
            for opIdx = 1:n_ops
                % get the index of different operators
                [m, c, f, cr, np] = opIdx2compon(opIdx, mutationTypes, crossoverTypes, F, CR, NP);
                
                optionalArgs.opIdx = opIdx;
                % set options
                options = setOptions(options, ...
                    'AlgoName', algo_name, 'Dim', dim, 'PopInitRange', [lb, ub], ...
                    'MutationType', mutationTypes{m}, 'CrossoverType', crossoverTypes{c}, ...
                    'F', F(f), 'CR', CR(cr), 'PopulationSize', NP(np));
                
                % run a DE
                parfor run_num = runStart:runEnd
                    rng(round(sum(clock) * 1000), 'twister');  % using time-based seed
                    %                     rng(run_num, 'twister');  % using same seed
                    feval(algo_name, run_num, func_names, func_num, options, optionalArgs);
                end
                
            end
        end
        delete(gcp('nocreate'));
    end
end

