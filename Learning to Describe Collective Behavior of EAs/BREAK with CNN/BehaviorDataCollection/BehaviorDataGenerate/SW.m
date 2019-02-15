%----------------------------------------------------------------------
% SW algorithm
%----------------------------------------------------------------------

function SW(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'SW';

parfor run = 1:runs
    SW_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag);
end

end