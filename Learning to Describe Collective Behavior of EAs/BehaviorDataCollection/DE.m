%----------------------------------------------------------------------
% Classical DE Algorithm
% Population size: NP = 100
% Function dimension: D = 30

% Mutation probability: F = 0.5
% Crossover probability: CR = 0.9
%----------------------------------------------------------------------

function DE(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag)

algo_name = 'DE';

parfor run = 1:runs
    DE_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag);
end

end