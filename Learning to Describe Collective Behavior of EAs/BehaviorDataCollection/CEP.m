%----------------------------------------------------------------------
% Classical EP algorithm
% Population size: NP = 100
% Function dimension: D = 30
%----------------------------------------------------------------------

function CEP(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag)

algo_name = 'CEP';

parfor run = 1:runs
    CEP_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag);
end

end