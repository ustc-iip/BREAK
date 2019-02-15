function ES_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag)
%ES_RUN Run ES algorithm once
mu = NP; % parent population size
lambada = 7 * mu; % offspring population size

x = initial_pop;
oldval = benchmark_func(x, func_num, shift_flag);
FEs = NP;
generation = 1;

% flags
savePopFit = 1;

sigma = 3 * ones(NP, D); % standard deviation for normal distribution in mutation
tau = 1 / sqrt(2 * sqrt(D)); % initialize tau, tau_2
tau_2 = 1 / sqrt(2 * D);
while (FEs < maxFEs)
    % recombination
    off_sigma = repmat(mean(sigma), lambada, 1); % intermediate recombination
    offspring = repmat(mean(x), lambada, 1); % intermediate recombination
    
    % mutation
    N = normrnd(0, 1, lambada, 1);
    Ni = repmat(N, 1, D); % all dimension share the same Ni;
    Nj = normrnd(0, 1, lambada, D);
    norm_j = normrnd(0, 1, lambada, D); % each dimension has its own Nj and norm_j
    new_sigma = off_sigma .* exp(tau_2 .* Ni + tau .* Nj); % create new sigma
    new_x = offspring + new_sigma .* norm_j; % create new x
    
    new_sigma(new_sigma <= 1e-4) = 1e-4;  % set lower bound of new_sigma
    %new_x = min(ub, max(lb,new_x));     % limit all population to [lb, ub]
    new_x = update_bound(new_x, lb, ub);
    
    % calculate fitness values
    new_val = benchmark_func(new_x, func_num, shift_flag);
    FEs = FEs + NP;
    generation = generation + 1;
    
    % selection for offspring and parent
    % pop = [x;new_x]; % create new population from x and new x
    % val = [oldval;new_val];
    % sigma_f = [sigma;new_sigma];
    [~, index] = sort(new_val); % select mu individual that have smaller fitness values
    x = new_x(index(1:mu), :);
    oldval = new_val(index(1:mu));
    sigma = new_sigma(index(1:mu), :);

    % Save population and corresponding fitness values
    if savePopFit ~= 0
            savePath = ['../result', filesep, 'raw_data', filesep, save_func_name{func_num}, filesep, algo_name];
            if ~isdir(savePath)
                mkdir(savePath);
            end
        save([savePath, filesep, num2str(run)], 'x', 'oldval');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d\n', algo_name, func_num, run);
end

