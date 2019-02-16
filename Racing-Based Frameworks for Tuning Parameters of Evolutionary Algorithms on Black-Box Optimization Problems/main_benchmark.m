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

% K-W Test + post-hoc + ADP to test performance of fitness
for d = 3
    dim = dims(d);
    for func_num = 1:13

        
        bestFitAllOperators = zeros(1); % init an array for saving
        % test KW benchmark data
        loadDataPath = ['result_race', filesep, 'KW', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}];
        
        flag = 0;
        alpha = 0.05;
        method = 'Holm';
        
        % load bestFitEachFunc matrix
        bestFitStr = load([loadDataPath, filesep, 'bestFitEachFunc.mat']);
        bestFitGroups = bestFitStr.bestFitEachFunc;
        % test best fitness value
        [~, ~, ~, ~, ~, ~, fit_best_ids] = ...
            kw_conover_control(bestFitGroups, flag, alpha, method);
        
        %         % load fstHitFEsEachFunc matrix
        %         fstHitFEsStr = load([loadDataPath, filesep, 'fstHitFEsEachFunc.mat']);
        %         fstHitFEsEachFunc = fstHitFEsStr.fstHitFEsEachFunc;
        %         combGroups = bestFitGroups .* fstHitFEsEachFunc;
        %         % test combined best fitness and fstHitFEs
        %         [~, ~, ~, ~, ~, ~, comb_best_ids] = ...
        %             kw_conover_control(combGroups, flag, alpha, method);
        
        % write best_ids to a csv file
        saveDataPath = ['result_race', filesep, 'F', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}];
        csvwrite([saveDataPath, filesep, 'bestOpId_fit.csv'], fit_best_ids);
        
        %         csvwrite([loadDataPath, filesep, 'bestOperatorId_comb.csv'], comb_best_ids);
        
    end
end

