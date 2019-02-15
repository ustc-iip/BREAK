%----------------------------------------------------------------------
% GA algorithm
%----------------------------------------------------------------------

function GA_4(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, savePop_step, shift_flag)

algo_name = 'GA_4';
inilb = lb;
iniub = ub;

parfor run = 1:runs
    GATBG_run(save_func_name, func_num, 'GATBG', maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag);
    GARBG_run(save_func_name, func_num, 'GARBG', maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag);
    GAUSU_run(save_func_name, func_num, 'GAUSU', maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag);
    GARAU_run(save_func_name, func_num, 'GARAU', maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag);
end

% Plot convergence trend of all runs
% for run_2 = 1:runs
%     saveFigPath = ['result', filesep, 'conver_trend', filesep, ...
%         save_func_name, filesep, algo_name, filesep, 'run_', num2str(run_2)];
%     saveIterPath = ['result', filesep, 'bestFEs', filesep, ...
%         save_func_name, filesep, algo_name];
%     if ~isdir(saveIterPath)
%         mkdir(saveIterPath);
%     end
%     if run_2 == 1
%         fIter = figure;
%         s1 = subplot(1,1,1);
%     end
%     load([saveFigPath, filesep, 'bestSolution']);
%     semilogy(s1, gval);
%     xlabel(s1, 'Generation');
%     ylabel(s1, 'Fitness Value');
%     title(s1, func_name{func_num});
%     grid on;
%     hold on;
% end
% %saveas(fIter, [saveIterPath, filesep, 'findBestFEs.jpg']);
% % print('-dtiff', '-r600', [saveIterPath, filesep, 'findBestFEs']);
% close(fIter);

end
