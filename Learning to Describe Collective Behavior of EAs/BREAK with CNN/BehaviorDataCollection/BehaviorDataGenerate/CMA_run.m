function gval = CMA_run(save_func_name, func_num, algo_name, maxFEs, run, NP, n, inilb, iniub, lb, ub, initial_pop, savePop_step, shift_flag)
%CMA-ES_RUN Run ES algorithm once

sigma = (iniub - inilb) / 3;          % coordinate wise standard deviation (step size)

% Strategy parameter setting: Selection
lambda = NP;  % population size, offspring number
mu = lambda/2;               % number of parents/points for recombination
weights = log(mu+1/2)-log(1:mu); % muXone array for weighted recombination
mu = floor(mu);
weights = weights/sum(weights);     % normalize recombination weights array
mueff=sum(weights)^2/sum(weights.^2); % variance-effectiveness of sum w_i x_i

% Strategy parameter setting: Adaptation
cc = (4 + mueff/n) / (n+4 + 2*mueff/n); % time constant for cumulation for C
cs = (mueff+2) / (n+mueff+5);  % t-const for cumulation for sigma control
c1 = 2 / ((n+1.3)^2+mueff);    % learning rate for rank-one update of C
cmu = min(1-c1, 2 * (mueff-2+1/mueff) / ((n+2)^2+mueff));  % and for rank-mu update
damps = 1 + 2*max(0, sqrt((mueff-1)/(n+1))-1) + cs; % damping for sigma

% Initialize dynamic (internal) strategy parameters and constants
pc = zeros(1, n); ps = zeros(1, n);   % evolution paths for C and sigma
B = eye(n, n);
Bt = B';                       % B defines the coordinate system, Bt is the transposition of B
D = ones(n, 1);
DBt = diag(D) * Bt;% diagonal n defines the scaling
C = B * diag(D.^2) * Bt;            % covariance matrix C
invsqrtC = B * diag(D.^-1) * Bt;    % C^-1/2
chiN=n^0.5*(1-1/(4*n)+1/(21*n^2));  % expectation of
%   ||n(0,I)|| == norm(randn(n,1))

% maxiter = ceil(maxFEs / NP);
% sigmaSave = zeros(maxiter, 1);
% Dsave = zeros(n, maxiter);

if isempty(initial_pop)
    % initialize pop every run
    x = lb + (ub - lb) * rand(NP, D);
else
    x = initial_pop;
end
value = benchmark_func(x, func_num, shift_flag); % fitness evaluation
[~, ind] = sort(value);
xmean = weights * x(ind(1:mu), :);

generation = 1;
FEs = NP;

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
    % mutation
    muta = sigma * randn(lambda, n) * DBt;
    x = repmat(xmean, lambda, 1) + muta;
    x = min(ub, max(lb, x));
    % calculate fitness values
    value = benchmark_func(x, func_num, shift_flag);
    FEs = FEs + NP;
    
    % selection for offspring and parent
    [~, ind] = sort(value);
    xold = xmean;
    xmean = weights * x(ind(1:mu), :);
    selmuta = muta(ind(1:mu), :) / sigma;
    
    % update ps and pc
    ps = (1 - cs) * ps...
       + sqrt(cs * (2 - cs) * mueff) * (xmean - xold) * invsqrtC / sigma;
    hsig = sqrt(sum(ps.^2)) / sqrt(1-(1-cs)^(2 * FEs / lambda)) / chiN < 1.4 + 2/(n+1);
    pc = (1 - cc) * pc...
       + hsig * (sqrt(cc * (2 - cc) * mueff) / sigma) * (xmean - xold);
   
    % update C and sigma
    C = (1 - c1 - cmu) * C + c1 * (pc' * pc) + cmu * selmuta' * diag(weights) * selmuta;
    sigma = sigma * exp(min(1, (sqrt(sum(ps.^2)) / chiN - 1) * cs / damps));
    
    % update B and D
    C = triu(C) + triu(C, 1)';
    [B, tmp] = eig(C);
    D = sqrt(diag(tmp));
    Bt = B';
    DBt = diag(D) * Bt;
    invsqrtC = B * diag(D.^-1) * Bt;  
    
    
%     sigmaSave(generation, :) = sigma;
%     Dsave(:, generation) = D;
    g_val = value(ind(1));
    gval(generation) = g_val;    % Set all population to the same min value of fitness
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
        save([savePath, filesep, num2str(FEs)], 'x', 'value');
    end
end

% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, g_val);
% 
% figure;
% semilogy(sigmaSave);
% figure;
% semilogy(Dsave(1, :));
% figure
% semilogy(gval);

% % save best solutions to file
% saveFigPath = ['result', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
% if ~isdir(saveFigPath)
%     mkdir(saveFigPath);
% end
% save([saveFigPath, filesep, 'bestSolution'], 'gval');
end

