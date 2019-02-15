function gval = SPSO2011_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)
%PSO_RUN Run PSO algorithm once
% Initailize
w = 1 / (2 * log(2));
c1 = 0.5 + log(2);
c2 = c1;

if isempty(initial_pop)
    % initialize pop every run
    pop = lb + (ub - lb) * rand(NP, D);
else
    pop = initial_pop;
end
vel = (inilb - pop) + (iniub - inilb) * rand(NP, D);   % initialize particles' speed

value = benchmark_func(pop, func_num, shift_flag);    % fitness evaluation
generation = 1;
FEs = NP;

pbest = pop;    % init positions of individual
pVal = value;    % init fitness values of individual

adaptNighs = true;

k = 3;
p = 1 - (1 - 1 / NP) ^ k;


[g_val, bestIndex] = min(value);  % best solution of each generation
gval(generation) = g_val;    % b\est fitness
gbest = pop(bestIndex, :);   % best individual of each generation
g_best(generation, :) = gbest;  % save the best individual of each generation

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
    if adaptNighs == true
        nighs = rand(NP) < p;
        for s = 1:NP
            nighs(s, s) = true;
        end
    end
    
    nighsVal = repmat(pVal', NP, 1);
    nighsVal(~nighs) = NaN;
    [~, lbestInd] = min(nighsVal, [], 2);
    
    sw = 3 * ones(NP, 1);
    c22 = c2 * ones(NP, 1);
    for i = 1:NP
        if lbestInd(i) == i
            sw(i) = 2;
            c22(i) = 0;
        end
    end
    G = pop + (c1 * (pbest - pop) + repmat(c22, 1, D) .* (pbest(lbestInd, :) - pop)) ./ repmat(sw, 1, D);
    radius = sqrt(sum((G - pop) .^ 2, 2));
    randSphere = randn(NP, D);
    normRandSpere = sqrt(sum(randSphere .^ 2, 2));
    newPop = randSphere ./ repmat(normRandSpere, 1, D) .* repmat(rand(NP, 1) .* radius, 1, D) + G;
    vel = w * vel + newPop - pop;
    pop = pop + vel;
    
    ind = pop < lb;
    pop(ind) = lb;
    vel(ind) = -0.5 * vel(ind);
    ind = pop > ub;
    pop(ind) = ub;
    vel(ind) = -0.5 * vel(ind);
    
    value = benchmark_func(pop, func_num, shift_flag);
    FEs = FEs + NP;
    ind = value < pVal;
    pVal(ind, :) = value(ind, :);
    pbest(ind, :) = pop(ind, :);
    [minval, bestIndex] = min(value);
    if minval < g_val
        g_val = minval;
        gbest = pop(bestIndex, :);
        adaptNighs = false;
    else
        adaptNighs = true;
    end
    
    generation = generation + 1;
    
    
    gval(generation) = g_val;  % Set all population to the same min value of fitness
    g_best(generation, :) = gbest; % best individual of next generation
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


% save best solutions to file
% saveFigPath = ['result', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
% if ~isdir(saveFigPath)
%     mkdir(saveFigPath);
% end
% save([saveFigPath, filesep, 'bestSolution'], 'gval');
end
