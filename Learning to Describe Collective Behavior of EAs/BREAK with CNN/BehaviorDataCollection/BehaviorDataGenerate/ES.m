%----------------------------------------------------------------------
% ES Algorithm
% Population size: NP = 100
% Function dimension: D = 30

% ES(mu / mu + lambada) algorithm
% with self-adaptation
% no marriage
% intermediate recombination
% plus-selection
% Population size: NP = 100
% Function dimension: D = 30
% mu = NP = 100  ----parent population size
% lambada = 7 * mu = 700  ----offspring population size
% rho = mu = 100  ----parent family size after marriage
% initialized sigma = 3  ----standard deviation for normal distribution in mutation
%----------------------------------------------------------------------

function ES(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'ES';

parfor run = 1:runs
    ES_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag);
end

end