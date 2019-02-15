function CEP_run(save_func_name, func_num, algo_name, maxFEs, run, initial_pop, lb, ub, NP, D, shift_flag)
%CEP_RUN Run CEP algorithm once
x = initial_pop;
oldval = benchmark_func(x, func_num, shift_flag);
FEs = NP;
generation = 1;
% flags
savePopFit = 1;

eta = 3 * ones(NP, D); % initialize eta, set all eta = 3
tau = 1 / sqrt(2 * sqrt(D)); % initialize tau, tau_2
tau_2 = 1 / sqrt(2 * D);
while (FEs < maxFEs)
    % creat offspring
    N = normrnd(0, 1, NP, 1);
    Ni = repmat(N, 1, D); % all dimension share the same Ni;
    Nj = normrnd(0, 1, NP, D);
    norm_j = normrnd(0, 1, NP, D); % every dimension has its own Nj and norm_j
    xnew = x + eta .* norm_j; % create new x
    eta_new = eta .* exp(tau_2 .* Ni + tau .* Nj); % create new eta
    
    eta_new(eta_new <= 1e-4) = 1e-4;  % set lower bound of eta_new
    %xnew = min(ub, max(lb,xnew));     % limit all population to [lb, ub]
    xnew = update_bound(xnew, lb, ub);
    
    % calculate fitness values
    newval = benchmark_func(xnew, func_num, shift_flag);
    FEs = FEs + NP;
    generation = generation + 1;
    
    % select good individuals to form new population
    pop = [x;xnew];
    val = [oldval;newval];
    eta_f = [eta;eta_new];
    q = round(0.1*NP);  % set to 10
    score = zeros(1, 2*NP);
    for i = 1:2*NP
        % save the number of individuals whose fitness are better than randomly selected
        a = randperm(2*NP);
        qval(1:q) = val(a(1:q));    % randomly seleted fitness values
        score(i) = sum(val(i)<qval);
    end
    [~, index] = sort(score,'descend'); % sort by descending order
    x = pop(index(1:NP),:); % select NP individuals to form new population
    oldval = val(index(1:NP)); % fitness values of new population
    eta = eta_f(index(1:NP),:); % select eta form new population
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