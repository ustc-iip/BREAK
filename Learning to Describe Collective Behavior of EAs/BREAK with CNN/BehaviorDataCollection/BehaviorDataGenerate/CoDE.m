%----------------------------------------------------------------------
% CoDE Algorithm
% Population size: NP = 100
% Function dimension: D = 30
%----------------------------------------------------------------------

function CoDE(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'CoDE';
inilb = lb;
iniub = ub;

parfor run = 1:runs
    CoDE_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag);
end


end
