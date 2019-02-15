function DE_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag)
%DE_RUN Run DE algorithm once
F = 0.5;    % mutation probability
CR = 0.9;   % crossover probability

pop = initial_pop;
val = benchmark_func(pop, func_num, shift_flag); % fitness evaluation

FEs = NP;
generation = 1;

% flags
savePopFit = 1;

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

    % Save population and corresponding fitness values
    if savePopFit ~= 0
        savePath = ['../result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name];
        if ~isdir(savePath)
            mkdir(savePath);
        end
        save([savePath, filesep, num2str(run)], 'pop', 'val');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d\n', ...
    algo_name, func_num, run);
end
