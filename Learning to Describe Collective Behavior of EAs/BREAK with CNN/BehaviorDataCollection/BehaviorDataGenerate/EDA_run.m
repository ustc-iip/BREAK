    
function gval = EDA_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)

maxGen = ceil(maxFEs /  NP);
selNum = ceil(NP * 0.15);
% initialize
if isempty(initial_pop)
    % initialize pop every run
    pop = lb + (ub - lb) * rand(NP, D);
else
    pop = initial_pop;
end
% evaluate
value = benchmark_func(pop, func_num, shift_flag);
FEs = NP;
generation = 1;

[g_val, index] = min(value);  % best solution of each generation
gval = g_val;
gval(generation) = g_val;
gbest = pop(index, :);   % best individual of each generation

% flags
if mod(FEs, savePop_step) == 0
    savePopFit = 1;
else
    savePopFit = 0;
end

% Save population and corresponding fitness values
if savePopFit ~= 0
    savePath = ['./result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name, filesep, 'run_', num2str(run)];
    if ~isdir(savePath)
        mkdir(savePath);
    end
    save([savePath, filesep, num2str(FEs)], 'pop', 'value');
end

while (FEs < maxFEs)
    
    
    [~, index] = sort(value);
    stdx = std(pop(index(1:selNum), :), 1);
    mStdx = 0.55 * mean(stdx);
    stdx(stdx < mStdx) = mStdx;
    meanx = mean(pop(index(1:selNum), :), 1);
	if D < 100
		p = 0.1;
	else
		p = 10 * rand(NP, D) / D;
	end
    pop = repmat(meanx, NP, 1) + repmat(stdx, NP, 1) .* ((1 - p) .* randn(NP, D) + p .* cauchyrnd(1, 1, NP, D));
    ind = pop < lb;
    pop(ind) = inilb + mod(inilb - pop(ind), (iniub - inilb));
    ind = pop > ub;
    pop(ind) = iniub - mod(pop(ind) - iniub, (iniub - inilb));
    value = benchmark_func(pop, func_num, shift_flag);
    FEs = FEs + NP;
    generation = generation + 1;
    
    [g_val, index] = min(value);  % best solution of each generation
    gval(generation) = g_val;    % Set all population to the same min value of fitness
    gbest = pop(index, :);   % best individual of each generation
    % flags
    if mod(FEs, savePop_step) == 0
        savePopFit = 1;
    else
        savePopFit = 0;
    end
    % Save population and corresponding fitness values
    if savePopFit ~= 0
        savePath = ['./result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name, filesep, 'run_', num2str(run)];
        if ~isdir(savePath)
            mkdir(savePath);
        end
        save([savePath, filesep, num2str(FEs)], 'pop', 'value');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, g_val);
% figure;
% semilogy(gval);
% % save best solutions to file
% saveFigPath = ['result', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
% if ~isdir(saveFigPath)
%     mkdir(saveFigPath);
% end
% save([saveFigPath, filesep, 'bestSolution'], 'gval');

end