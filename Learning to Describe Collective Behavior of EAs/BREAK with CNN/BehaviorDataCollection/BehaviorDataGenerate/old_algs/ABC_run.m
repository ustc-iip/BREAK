function gval = ABC_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)
%ABC_RUN Run ABC algorithm once

foodNumber = NP;  % The number of food sources equals the half of the colony size
limit = 100;    % A food source which could not be improved through "limit" trials is abandoned by its employed bee

% All food sources are initialized
if isempty(initial_pop)
    % initialize pop every run
    foods = lb + (ub - lb) * rand(NP, D);
else
    foods = initial_pop;
end
objVal = benchmark_func(foods, func_num, shift_flag);
FEs = foodNumber;
generation = 1;
fitness = calculateFitness(objVal);

%reset trial counters
trial = zeros(1, foodNumber);

% The best food source is memorized
[globalMin, bestInd] = min(objVal);
gval(generation) = globalMin;
globalParams = foods(bestInd, :);

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
    save([savePath, filesep, num2str(FEs)], 'foods', 'objVal');
end


while FEs < maxFEs
    % ---- EMPLOYED BEE PHASE ---- %
    for i = 1:foodNumber    % the number of employed bee is same as the food number
        % The parameter to be changed is determined randomly
        param2Change = fix(rand*D)+1;        % fix function
        % A randomly chosen solution is used in producing a mutant solution of the solution i
        neighbour = fix(rand*(foodNumber))+1;
        % Randomly selected solution must be different from the solution i
        while neighbour == i
            neighbour = fix(rand*(foodNumber))+1;
        end
        sol = foods(i,:);
        %  v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
        sol(param2Change) = foods(i,param2Change)+(foods(i,param2Change)-foods(neighbour,param2Change))*(rand-0.5)*2;
        %  if generated parameter value is out of boundaries, it is shifted onto the boundaries
        sol = max(min(sol,ub), lb);
        % evaluate new solution
        objValSol = benchmark_func(sol, func_num, shift_flag);
        FEs = FEs+1;
        fitnessSol = calculateFitness(objValSol);
        % a greedy selection is applied between the current solution i and its mutant
        if fitnessSol > fitness(i) % If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i
            foods(i,:) = sol;
            fitness(i) = fitnessSol;
            objVal(i) = objValSol;
            trial(i) = 0;
        else
            trial(i) = trial(i) + 1; % if the solution i can not be improved, increase its trial counter
        end
    end
    % ---- CalculateProbabilities ---- %
    % A food source is chosen with the probability which is proportioal to its quality
    % Different schemes can be used to calculate the probability values
    % For example prob(i)=fitness(i)/sum(fitness)
    % or in a way used in the metot below prob(i) = a*fitness(i)/max(fitness)+b
    % probability values are calculated by using fitness values and normalized by dividing maximum fitness value
    prob = (0.9.*fitness./max(fitness)) + 0.1;  % the probability of onlooker bees to select foods
    % ---- ONLOOKER BEE PHASE ---- %
    i = 1;
    t = 0;
    while t < foodNumber
        if rand < prob(i)
            t = t+1;
            % The parameter to be changed is determined randomly
            param2Change = fix(rand*D)+1;
            % A randomly chosen solution is used in producing a mutant solution of the solution i
            neighbour = fix(rand*(foodNumber))+1;
            % Randomly selected solution must be different from the solution i
            while(neighbour == i)
                neighbour = fix(rand*(foodNumber))+1;
            end
            sol = foods(i,:);
            % v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
            sol(param2Change) = foods(i,param2Change)+(foods(i,param2Change)-foods(neighbour,param2Change))*(rand-0.5)*2;
            % if generated parameter value is out of boundaries, it is shifted onto the boundaries
            sol = max(min(sol,ub), lb);
            % evaluate new solution
            objValSol = benchmark_func(sol, func_num, shift_flag);
            FEs = FEs+1;
            fitnessSol = calculateFitness(objValSol);
            % a greedy selection is applied between the current solution i and its mutant
            if fitnessSol > fitness(i) % If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i
                foods(i,:) = sol;
                fitness(i) = fitnessSol;
                objVal(i) = objValSol;
                trial(i) = 0;
            else
                trial(i) = trial(i)+1; % if the solution i can not be improved, increase its trial counter
            end
        end
        i = i+1;
        if i == foodNumber+1
            i = 1;
        end
    end
    % ---- SCOUT BEE PHASE ---- %
    % determine the food sources whose trial counter exceeds the "limit" value.
    % In Basic ABC, only one scout is allowed to occur in each cycle
    ind = find(trial==max(trial));
    ind = ind(end);
    if trial(ind) > limit
        trial(ind) = 0;
        % Bas(ind)=0;
        sol = rand(1,D) .* (iniub-inilb) + inilb;
        objValSol = benchmark_func(sol, func_num, shift_flag);
        % FEs = FEs+1;
        fitnessSol = calculateFitness(objValSol);
        foods(ind,:) = sol;
        fitness(ind) = fitnessSol;
        objVal(ind) = objValSol;
    end
    % update best solution
    ind = find(objVal == min(objVal));
    ind = ind(end);
    if objVal(ind) < globalMin
        globalMin = objVal(ind);
        globalParams = foods(ind,:);
    end
    
    gval(generation) = globalMin;    % Set all population to the same min value of fitness
    generation = generation + 1;
    
    % Save population and corresponding fitness values
    if savePopFit ~= 0
        savePath = ['./result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name, filesep, 'run_', num2str(run)];
        if ~isdir(savePath)
            mkdir(savePath);
        end
        save([savePath, filesep, num2str(FEs)], 'foods', 'objVal');
    end
    
    
end     % End of ABC

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, globalMin);

% save best solutions to file
% saveFigPath = ['result', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
% if ~isdir(saveFigPath)
%     mkdir(saveFigPath);
% end
% save([saveFigPath, filesep, 'bestSolution'], 'gval');

end

function fFitness=calculateFitness(fObjV)
% calculate fitness value in ABC algorithm
fFitness=zeros(size(fObjV));
ind=find(fObjV>=0);
fFitness(ind)=1./(fObjV(ind)+1);
ind=find(fObjV<0);
fFitness(ind)=1+abs(fObjV(ind));
end
