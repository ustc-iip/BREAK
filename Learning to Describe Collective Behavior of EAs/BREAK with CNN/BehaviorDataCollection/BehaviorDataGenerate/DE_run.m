function DE_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, savePop_step, shift_flag)
%DE_RUN Run DE algorithm once
F = 0.5;    % mutation probability
CR = 0.9;   % crossover probability

if isempty(initial_pop)
    % initialize pop every run
    pop = lb + (ub - lb) * rand(NP, D);
else
    pop = initial_pop;
end
val = benchmark_func(pop, func_num, shift_flag); % fitness evaluation

FEs = NP;
generation = 1;

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
    % random search, you should add your own method
    v = zeros(NP, D);   % initialize population
    newindiv = zeros(1, D); % initialize individuals
    for i = 1:NP
        % mutation operation
        d = round(rand*(NP-1)) + 1;
        b = round(rand*(NP-1)) + 1;
        while  b==i || b==d
            b = round(rand*(NP-1)) + 1;
        end
        c = round(rand*(NP-1)) + 1;
        while c==i || c==d || c==b
            c = round(rand*(NP-1)) + 1;
        end
        v(i,:) = pop(d,:) + F .* (pop(b,:)-pop(c,:));
        v(i,:) = update_bound(v(i,:), lb, ub);
        z = round(rand*(D-1)) + 1;
        
        % crossover operation
        for j = 1:D
            if rand<=CR || j==z
                newindiv(j) = v(i,j);
            else
                newindiv(j) = pop(i,j);
            end
        end
        
        % selecting operation
        newval = benchmark_func(newindiv, func_num, shift_flag);
        
        if newval < val(i)
            val(i) = newval;
            pop(i,:) = newindiv;
        end
    end
    FEs = FEs + NP;
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
        save([savePath, filesep, num2str(FEs)], 'pop', 'val');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d\n', ...
    algo_name, func_num, run);
end
