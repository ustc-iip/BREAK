% Execute the whole process
clear; clc; close all;

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
options = setOptions(); % init options

treatment_sum = length(mutationTypes) * length(crossoverTypes) * length(F) * length(CR) * length(NP);
block_sum = runEnd - runStart + 1;
algo_name = algo_names{1};

ratio_cost = zeros(1, 13);
for func_num = 1:13
    
    for d = 3
        dim = dims(d);
        
        options = setOptions(options, 'AlgoName', algo_name, 'Dim', dim); % init options
        
        % init a folder to save results
        savepath = ['result_race', filesep, 'F-KW', filesep, 'dim_', num2str(dim), filesep, func_names{func_num}];
        if ~isdir(savepath)
            mkdir(savepath);
        end
        
        % init variables
        block_count = 1;
        treatment = true(1, treatment_sum);  % logical array
        op_ids = 1: treatment_sum;  % operator id
        op_left = op_ids(treatment);  % remaining operator id
        op_left_num = treatment_sum;  % number of remaining operators
        
        %         % execute DE with different operator configurations
        %         callDE(block_sum,  treatment, func_num, savepath, race_num, mutationTypes, crossoverTypes, F, CR, NP);
        
        %         % gather final results (also perform precision correction for float-pointing numbers)
        %         savebestFitAll('KW_result', savepath, 40, treatment, func_names, func_num, mutationTypes, crossoverTypes, F, CR, NP, options);
        
        loadpath =  ['result_race', filesep, 'KW', filesep, 'dim_', num2str(dim), filesep, func_names{func_num}];
        % load bestFitAll
        bestFitEachFuncStr = load([loadpath, filesep, 'bestFitEachFunc.mat']);
        bestFitEachFunc = bestFitEachFuncStr.bestFitEachFunc;
        bestFitAll = bestFitEachFunc(1:block_sum, :);
        
        % load fstHitAll
        fstHitFEsEachFuncStr = load([loadpath, filesep, 'fstHitFEsEachFunc.mat']);
        fstHitFEsEachFunc = fstHitFEsEachFuncStr.fstHitFEsEachFunc;
        fstHitAll = fstHitFEsEachFunc(1:block_sum, :);
        
        alpha = 0.05;
        left_ids = op_ids;
        equal_count = 0;  % init a variable to count the times of no statistical significance
        flag = 0;  % flag to judge which race is employed
        while block_count <= runEnd && sum(treatment) > 1
            % left candidates
            if flag == 0
                candidates = bestFitAll(1:block_count, treatment);
            end
            
            if block_count >= 2
                % perform Friedman Test
                [p_f, Q, Rmean, control_id, p_corrected, reject, best_ids] = ...
                    kw_conover_control(candidates, 0, alpha, 'Holm');
                
                if p_f > 0.05
                    % no statistical significance among treatments
                    if block_count == 1
                        op_left_num(1) = op_left_num(block_count);
                        op_left(1, :) = op_left(block_count , :);
                    else
                        op_left_num(1, block_count) = op_left_num(1, block_count-1);
                        op_left(block_count, : ) = op_left(block_count-1, :);
                    end
                    left_ids = op_ids(treatment);  % update left ids
                    if flag == 0
                        equal_count = equal_count + 1;  % increase equal_count
                    end
                else
                    % statistical significance
                    treatment = false(1, treatment_sum);  % init an all-false array
                    treatment(left_ids(best_ids)) = true(1, length(best_ids));  % let left ids be true
                    
                    op_left_num(1, block_count) = sum(treatment);  % the number of left ids
                    left_ids = op_ids(treatment);  % update left ids
                    op_left(block_count, 1:sum(treatment)) = left_ids;
                    if flag == 0
                        equal_count = 0;  % clear equal_count
                    end
                end
            end
            
            if equal_count == 2
                combAll = bestFitAll .* fstHitAll;
                candidates = combAll(1:block_count, treatment);
                flag = 1;  % keep until end
            end
            
            block_count = block_count + 1; % update blockcount
            
        end
        
        % write results
        csvwrite( [savepath, filesep, 'OpLeftNum.csv'], op_left_num);
        csvwrite([savepath, filesep,  'OpLeft.csv'], op_left);
        
        ratio_cost(func_num) = 100 * sum(op_left_num) / (block_sum * length(treatment));  % cost of KW-Race / cost of benchmark
        figure('Visible', 'off');
        plot(op_left_num, 'g-^','markersize', 4);
        xlabel('Restarts');
        ylabel('Left Parameter Configurations');
        title( 'Procedure of F-KW-Race');
        grid on;
        print([savepath, filesep, 'F-KW-Race'], '-depsc', '-r1200');
        close;
        
    end
end
csvwrite( ['result_race', filesep, 'F-KW', filesep, 'ratio_cost.csv'], ratio_cost);