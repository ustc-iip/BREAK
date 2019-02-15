function gval = SW_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag)

maxSuccess = 5;
maxFailed = 5;
adjSucc = 4;
adjFail = 0.75;
delta = 2.4;
successes = 0;
failures = 0;
% initialize
x = inilb + (iniub-inilb)*rand(1, D);

% evaluate
val = benchmark_func(x, func_num);
FEs = 1;
generation = 1;

gval(generation) = val;    % best fitness

while FEs < maxFEs
    d = delta * randn(1, D);
    xTest = x + d;
    xTest = min(ub, max(lb, xTest));
    valTest = benchmark_func(xTest, func_num);
    FEs = FEs + 1;
    if valTest < val;
        x = xTest;
        val = valTest;
        successes = successes + 1;
        failures = 0;
    else
        xTest = x - d;
        xTest = min(ub, max(lb, xTest));
        valTest = benchmark_func(xTest, func_num);
        FEs = FEs + 1;
        if valTest < val;
            x = xTest;
            val = valTest;
            successes = successes + 1;
            failures = 0;
        else
            failures = failures + 1;
            successes = 0;
        end
    end
    if successes > maxSuccess
        delta = delta * adjSucc;
    end
    if failures > maxFailed
        delta = delta * adjFail;
    end
    generation = generation + 1;
    gval(generation) = val;
end

g_val = val;

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, g_val);

% save best solutions to file
saveFigPath = ['result', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
if ~isdir(saveFigPath)
    mkdir(saveFigPath);
end
save([saveFigPath, filesep, 'bestSolution'], 'gval');

end
        
        
    