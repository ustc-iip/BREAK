function gval = PSO_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)
%PSO_RUN Run PSO algorithm once
% Initailize
Vmax = (ub - lb); % max velocity of particles
cc = [2.05, 2.05];    % acceleration constants
% cc(1): coefficient of particle tracking best value of its own in history.
% cc(2): coefficient of particle tracking best value of the population in history.
constriction = 0.7298;  % inertia weight
vel = inilb + (iniub - inilb) * rand(NP, D);   % initialize particles' speed
if isempty(initial_pop)
    % initialize pop every run
    pop = lb + (ub - lb) * rand(NP, D);
else
    pop = initial_pop;
end

val = benchmark_func(pop, func_num, shift_flag);    % fitness evaluation
generation = 1;
FEs = NP;

pbest = pop;    % init positions of individual
p_val = val;    % init fitness values of individual

[g_val, index] = min(val);  % best solution of each generation
gval(generation) = g_val;    % best fitness
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
    save([savePath, filesep, num2str(FEs)], 'pop', 'val');
end

while (FEs < maxFEs)
    
    vel = constriction * (vel + cc(1) .* rand(NP, D) .* (pbest - pop) + cc(2) .* rand(NP, D) .* (repmat(gbest, NP, 1) - pop));
    vel = min(Vmax, max(-Vmax, vel));
    pop = pop + vel;
    pop = min(ub, max(lb, pop));   % don't need this, and it will worsen the result
%     ind = find((pop > ub) | (pop < lb)); % don't need this, and it will worsen the result
%     pop(ind) = inilb + (iniub - inilb) * rand(size(ind));
    val = benchmark_func(pop, func_num, shift_flag);
    ind = val < p_val;
    p_val(ind, :) = val(ind, :);
    pbest(ind, :) = pop(ind, :);
    [minval, ind] = min(val);
    if minval < g_val
        g_val = minval;
        gbest = pop(ind, :);
    end
    
    FEs = FEs + NP;
    generation = generation + 1;
    
    
    gval(generation) = g_val;  % Set all population to the same min value of fitness
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
        save([savePath, filesep, num2str(FEs)], 'pop', 'val');
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
