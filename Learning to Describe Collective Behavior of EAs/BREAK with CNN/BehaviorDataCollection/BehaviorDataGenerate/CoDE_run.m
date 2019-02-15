function gval = CoDE_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)

strategiesNum = 3;
F = [1, 1, 0.8];
CR = [0.1, 0.9, 0.2];
if isempty(initial_pop)
    % initialize pop every run
    pop = inilb + (iniub - inilb) * rand(NP, D);
else
    pop = initial_pop;
end
value = benchmark_func(pop, func_num, shift_flag); 
FEs = NP;
generation = 1;

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


while FEs < maxFEs
    % generate mutaMatrix for mutation
    
    newPop = zeros(NP * (strategiesNum), D);
    newVal = zeros(NP, strategiesNum);
    randp = randperm(strategiesNum);
    for i = 1:strategiesNum
        selFCR = randp(i);
        % generate crossoverIndex
        selIndex = rand(NP, D) < CR(selFCR);
        randJ = randi(D, NP, 1);
        for k = 1:NP
            selIndex(k, randJ(k)) = true;
        end
        sel = ~selIndex;
        if i == 1
            % rand/1/bin
            mutaSize1 = 3;
            mutaMatrix = zeros(mutaSize1, NP);
            for j = 1:NP
                mutaMatrix(:, j) = randperm(NP, mutaSize1);
            end
            tempPop = pop(mutaMatrix(1, :), :) + F(selFCR) .* (pop(mutaMatrix(2, :), :) - pop(mutaMatrix(3, :), :));
            tempPop(sel) = pop(sel);
        elseif i == 2
            % rand/2/bin
            mutaSize1 = 5;
            mutaMatrix = zeros(mutaSize1, NP);
            for j = 1:NP
                mutaMatrix(:, j) = randperm(NP, mutaSize1);
            end
            tempPop = pop(mutaMatrix(1, :), :) + repmat(rand(NP, 1), 1, D) .* (pop(mutaMatrix(2, :), :) - pop(mutaMatrix(3, :), :))...
                + F(selFCR) .* (pop(mutaMatrix(4, :), :) - pop(mutaMatrix(5, :), :));
            tempPop(sel) = pop(sel);
        elseif i == 3
            % current to rand/1
            mutaMatrix = randi(NP, 3, NP);
            tempPop = pop + repmat(rand(NP, 1), 1, D) .* (pop(mutaMatrix(1, :), :) - pop) + ...
                F(selFCR) .* (pop(mutaMatrix(2, :), :) - pop(mutaMatrix(3, :), :));
        end
        newPop((1:NP) + NP * (i - 1), :) = tempPop;
    end
    % keep individuals inside the search range
    exceededInd = newPop < lb;
    newPop(exceededInd) = min(ub,  2 * lb - newPop(exceededInd)); % limit population in [lb, ub]
    exceededInd = newPop > ub;
    newPop(exceededInd) = max(lb,  2 * ub - newPop(exceededInd)); % limit population in [lb, ub]
    
    newVal(:) = benchmark_func(newPop, func_num,shift_flag);
    FEs = FEs + 3 * NP;
    
    [selVal, minInd] = min(newVal, [], 2);
    minInd = (minInd - 1) * NP + (1:NP)';
    selPop = newPop(minInd, :);
    minInd = selVal <= value;
    value(minInd) = selVal(minInd);
    pop(minInd, :) = selPop(minInd, :);
    g_val = min(value);
    
     generation = generation + 1;
     gval(generation) = g_val;
    
     
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


end
