%----------------------------------------------------------------------
% GA algorithm
% Population size: NP = 100
% Function dimension: D = 30
% Selection: roulette wheel selection
% with elites select
% Crossover: single point crossover 
% Mutation: unifrom mutation
%----------------------------------------------------------------------

function GAc5(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'GAc5';

parfor run = 1:runs
    GAc5_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag);
end

end