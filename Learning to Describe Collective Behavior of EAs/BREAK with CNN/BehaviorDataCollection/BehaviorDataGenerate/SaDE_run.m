function gval = SaDE_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)
%SaDE_RUN Run SaDE algorithm once
strategiesNum = 4;
iniF = 0.5;    % mutation probability
CRms = 0.5 * ones(1, strategiesNum);   % crossover probability
CRms(end) = 1;

learningGen = 50;
CRRec = cell(learningGen, strategiesNum);
numOfSuccess = zeros(learningGen, strategiesNum);
numOfFailure = zeros(learningGen, strategiesNum);
partRates = ones(1, strategiesNum);

if isempty(initial_pop)
    % initialize pop every run
    pop = lb + (ub - lb) * rand(NP, D);
else
    pop = initial_pop;
end
value = benchmark_func(pop, func_num, shift_flag); % fitness evaluation

newPop = zeros(NP, D);

FEs = NP;
generation = 1;

[g_val, index] = min(value);  % best solution of each generation
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
    save([savePath, filesep, num2str(FEs)], 'pop', 'value');
end

while (FEs < maxFEs)
    % generate mutaMatrix for mutation
    mutaSize1 = 5;
    mutaMatrix = zeros(mutaSize1, NP);
    mutaMatrix(1, :) = randperm(NP, NP);
    randShift = randperm(mutaSize1);
    for i = 2:mutaSize1
        mutaMatrix(i, :) = circshift(mutaMatrix(1, :), randShift(i), 2);
    end
     
     % select strategis for every individuals
     partProbabilitis = partRates / sum(partRates);
     cumPartProbs = cumsum(partProbabilitis);
     randPointers = (1 / NP * rand):(1 / NP):1;
     selNums = zeros(1, strategiesNum + 1);
     selStrategiesIndex = false(NP, strategiesNum);
     index = randperm(NP);
     for i = 1:strategiesNum
         selNums(i + 1) = sum(randPointers <= cumPartProbs(i));
         selStrategiesIndex(index((selNums(i) + 1):selNums(i + 1)), i) = true;
     end
     
     % generate cr for every individuals
     CR = normrnd(repmat(CRms, NP, 1), 0.1);
     CR(:, end) = 1;
     [indx, indy] = find(CR < 0 | CR > 1);
     for i = 1:length(indy)
         tmp = normrnd(CRms(indy(i)), 0.1);
         while tmp < 0 || tmp > 1
             tmp = normrnd(CRms(indy(i)), 0.1);
         end
         CR(indx(i), indy(i)) = tmp;
     end
     CR = CR';
     CR = CR(selStrategiesIndex');
     
     % generate crossoverIndex
     selIndex = rand(NP, D) < repmat(CR, 1, D);
     randJ = randi(D, NP, 1);
     for i = 1:NP
         selIndex(i, randJ(i)) = 1;
     end
     selIndex = ~selIndex;
     
     % generate F
     F = normrnd(iniF, 0.3, NP, 1);
     F = repmat(F, 1, D);
     
     % mutation
     ind = selStrategiesIndex(:, 1);
     newPop(ind, :) = pop(mutaMatrix(3, ind), :) + F(ind, :) .* (pop(mutaMatrix(1, ind), :) - pop(mutaMatrix(2, ind), :));
     ind = selStrategiesIndex(:, 2);
     newPop(ind, :) = pop(ind, :) + F(ind, :) .* (repmat(gbest, sum(ind), 1) - pop(ind, :)) + ...
         F(ind, :) .* (pop(mutaMatrix(1, ind), :) - pop(mutaMatrix(2, ind), :)...
         + pop(mutaMatrix(3, ind), :) - pop(mutaMatrix(4, ind), :));
     ind = selStrategiesIndex(:, 3);
     newPop(ind, :) = pop(mutaMatrix(5, ind), :) + F(ind, :) .* (pop(mutaMatrix(1, ind), :) - pop(mutaMatrix(2, ind), :)...
         + pop(mutaMatrix(3, ind), :) - pop(mutaMatrix(4, ind), :));
     ind = selStrategiesIndex(:, 4);
     newPop(ind, :) = pop(ind, :) + repmat(rand(sum(ind), 1), 1, D) .* (pop(mutaMatrix(5, ind), :) - pop(ind, :)) + ...
         F(ind, :) .* (pop(mutaMatrix(1, ind), :) - pop(mutaMatrix(2, ind), :));
     % keep individuals inside the search range
     exceededInd = (newPop < lb) | (newPop > ub);
     newPop(exceededInd) = inilb + (iniub - inilb) * rand(1, sum(sum(exceededInd))); % limit population in [lb, ub]
    
    % crossover
    newPop(selIndex) = pop(selIndex);
    
    % benchmark
    newval = benchmark_func(newPop, func_num, shift_flag);
    FEs = FEs + NP;
    successIndex = newval < value;
    value(successIndex) = newval(successIndex);
    pop(successIndex, :) = newPop(successIndex, :);
    
    % record numOfSuccess, numOfFailure and CR
    gen = mod(generation - 1, learningGen) + 1;
    numOfSuccess(gen, :) = sum(selStrategiesIndex(successIndex, :), 1);
    numOfFailure(gen, :) = sum(selStrategiesIndex(~successIndex, :), 1);
    for i = 1:strategiesNum
        selStrategiesIndex(~successIndex, i) = false;
        CRRec{gen, i} = CR(selStrategiesIndex(:, i));
    end
    
    [g_val, index] = min(value);  % best solution of each generation
    gval(generation) = g_val;    % Set all population to the same min value of fitness
    gbest = pop(index, :);   % best individual of each generation
    
    % adapt partRates and CRm
    if generation >= learningGen 
        sumOfSuccess = sum(numOfSuccess, 1);
        sumOfFailure = sum(numOfFailure, 1);
        sumOfFailure(sumOfSuccess + sumOfFailure == 0) = 1;
        partRates = sumOfSuccess ./ (sumOfSuccess + sumOfFailure) + 0.01;
        for i = 1:strategiesNum
            theCRRec = cell2mat(CRRec(:, i));
            if ~isempty(theCRRec)
                CRms(i) = median(theCRRec);
            else
                CRms(i) = rand;
            end
        end
    end
    
    generation = generation + 1;
    
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
