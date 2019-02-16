for func_num = 1: 14
    [lb, ub] = get_lb_ub(func_num);
    for d = 3
         dim = dims(d);
         if func_num == 14
             dim = 20;
         end
         
        load(['result_bench', filesep, 'conver_trend', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}, filesep, 'bestFitEachFunc.mat']);
        load(['result_bench', filesep, 'conver_trend', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}, filesep, 'fstHitFEsEachFunc.mat']);
        bestFitAll = bestFitEachFunc;
        bestFitAllFEs = fstHitFEsEachFunc;
        r = randperm(size(bestFitAll, 1));
        bestFitEachFunc_perm = bestFitAll(r, :);
        fstHitFEsEachFunc_perm = bestFitAllFEs(r, :);
        
        save(['result_bench', filesep, 'conver_trend', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}, filesep, 'bestFitEachFunc_perm.mat'], 'bestFitEachFunc_perm');
        save(['result_bench', filesep, 'conver_trend', filesep, 'dim_', num2str(dim), ...
            filesep, func_names{func_num}, filesep, 'fstHitFEsEachFunc_perm.mat'], 'fstHitFEsEachFunc_perm');
    end
end