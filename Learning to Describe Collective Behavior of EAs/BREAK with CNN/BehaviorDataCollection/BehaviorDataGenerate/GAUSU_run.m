function gval = GAUSU_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)

p_crossover = 0.9; % crossover rate
p_mutation = 0.01; % mutation rate
% initialize
if isempty(initial_pop)
    % initialize pop every run
    x = lb + (ub - lb) * rand(NP, D);
else
    x = initial_pop;
end

% evaluate
value = benchmark_func(x, func_num, shift_flag);
FEs = NP;
generation = 1;

[g_val, index] = min(value);  % best solution of each generation
gval(generation) = g_val;    % best fitness
gbest = x(index, :);   % best individual of each generation

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
    save([savePath, filesep, num2str(FEs)], 'x', 'value');
end

while (FEs < maxFEs)
    
    nXoverKids = 2 * round(p_crossover * NP / 2); % number of kids which will survived to next generation
    nParents = NP;           % number of parents for mutation and crossover
    
    % selection uniform
    parents = randi(size(x, 1), nParents, 1);
    
    parents = parents(randperm(length(parents)));
    parents1 = parents(1:(nXoverKids/2));
    parents2 = parents(((nXoverKids/2) + 1):(nXoverKids));
    
    
    % crossover simple
    xoverKids = zeros(NP, D);
    selDim = randi((D - 1), NP, 1);
    xoverKids(1:(nXoverKids/2), :) = [x(parents1, 1:selDim), x(parents2, (selDim + 1):end)];
    xoverKids(((nXoverKids/2) + 1):(nXoverKids), :) = [x(parents2, 1:selDim), x(parents1, (selDim + 1):end)];
    xoverKids = min(ub, max(lb, xoverKids));
    xoverKids((nXoverKids):end, :) = x(parents(nXoverKids:end), :);
    
    % mutation uniform
    mutation_matrix = rand(size(xoverKids));
    ind = find(mutation_matrix < p_mutation);
    %     xoverKids(ind) = inilb + (iniub - inilb) .* rand(1, length(ind));
    xoverKids(ind) = inilb + (iniub - inilb) * rand(size(ind));
    xoverKids = min(ub, max(lb, xoverKids));
    % evaluate
    newvalue = benchmark_func(xoverKids, func_num, shift_flag);
    FEs = FEs + NP;
    generation = generation + 1;
    
    xtest = [xoverKids; x];
    valtest = [newvalue; value];
    [~, ind] = sort(valtest);
    x = xtest(ind(1:NP), :);
    value = valtest(ind(1:NP));
    
    
    [g_val, index] = min(value);  % best solution of each generation
    gval(generation) = g_val;     % Set all population to the same min value of fitness
    gbest = x(index, :);   % best individual of each generation
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
        save([savePath, filesep, num2str(FEs)], 'x', 'value');
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