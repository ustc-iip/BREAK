function GA_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag)
p_crossover = 0.8; % crossover rate
p_mutation = 0.05; % mutation rate
nEliteKids = round(0.1 * NP);
% initialize
x = initial_pop;

% evaluate
value = benchmark_func(x, func_num, shift_flag);
FEs = NP;
generation = 1;

% flags
savePopFit = 1;

while (FEs < maxFEs)
    nXoverKids = round(p_crossover * NP - nEliteKids); % number of kids which will survived to next generation
    nMutateKids = NP - nEliteKids - nXoverKids;        % number of kids for mutation
    nParents = 2 * nXoverKids + nMutateKids;           % number of parents for mutation and crossover
    
    % selection
    [~, ind] = sort(value);
    expectation = zeros(size(value));
    expectation(ind) = 1./ ((1:length(value)) .^ 0.5);
    expectation = nParents * expectation ./ sum(expectation);
    wheel = cumsum(expectation) / nParents;
    parents = zeros(1,nParents);
    for i = 1:nParents
        r = rand;
        for j = 1:length(wheel)
            if(r < wheel(j))
                parents(i) = j;
                break;
            end
        end
    end
    [~,k] = sort(value);
    parents = parents(randperm(length(parents)));
    
    % eliteSelect
    eliteKids = x(k(1:nEliteKids), :);
    
    % crossover arithmetical
    % Allocate space for the kids
    xoverKids = zeros(nXoverKids,D);
    % To move through the parents twice as fast as the kids are
    % being produced, a separate index for the parents is needed
    index = 1;
    % for each kid...
    for i=1:nXoverKids
        % get parents
        r1 = parents(index);
        index = index + 1;
        r2 = parents(index);
        index = index + 1;
        % Children are arithmetic mean of two parents
        alpha = rand;
        xoverKids(i,:) = alpha*x(r1,:) + (1-alpha)*x(r2,:);
    end
    
    % mutation random
    mutateKids = x(parents((1 + 2 * nXoverKids):end), :);
    mutation_matrix = rand(size(mutateKids));
    ind = find(mutation_matrix < p_mutation);
    mutateKids(ind) = (lb + ub)/2 + (ub - lb)*((sum(rand(length(ind), 12), 2)-6))/6;

    % next population
    x = [eliteKids; xoverKids; mutateKids];
    
    % evaluate
    value = benchmark_func(x, func_num, shift_flag);
    FEs = FEs + NP;
    generation = generation + 1;

    % Save population and corresponding fitness values
    if savePopFit ~= 0
            savePath = ['../result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name];
            if ~isdir(savePath)
                mkdir(savePath);
            end
        save([savePath, filesep, num2str(run)], 'x', 'value');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d\n', algo_name, func_num, run);
end