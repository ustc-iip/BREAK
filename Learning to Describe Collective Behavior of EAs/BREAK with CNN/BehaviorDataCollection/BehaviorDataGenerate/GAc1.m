%----------------------------------------------------------------------
% GA algorithm
% Population size: NP = 100
% Function dimension: D = 30
% Selection: roulette wheel selection
% with elites select
% Crossover: single point crossover 
% Mutation: unifrom mutation
%----------------------------------------------------------------------

function GAc1(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'GAc1';

parfor run = 1:runs
    GAc1_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag);
end

end