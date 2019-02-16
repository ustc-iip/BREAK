function DE_core( run_num, func_names, func_num, options, optionalArgs )
% Perform the core part of Differential Evolution.
%   Parameters:
%   run_num             - The number of run times
%                       [positive scalar]
%   func_names          - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
%   f_bias              - Bias of the function value
%                       [vector]
%   options             - The options set by setOptions()
%                       [struct array]
%   optionalArgs        - The optional arguments, feasible fields include
%                         'InitPopulation', 'InitFitness', 'fst_num', 'variables'
%                       [struct array]
%   Fields of optionalArgs:
%   InitPopulation      - The initial population used in seeding the GA
%                         algorithm
%                       [ Matrix | [] ]
%   InitFitness         - The initial fitness values used to determine fitness
%                       [ column vector | [] ]
%   fst_num             - The number of first generation, it is also a flag
%                         to check whether to generate just one offspring
%                       [positive scalar]
%   variables           - Inner variables provided by the first generation
%                       [struct array]


% % set different rand number generator in each run
% rng(round(sum(clock) * 1000) + run_num * 100, 'twister');

% rng(run_num, 'twister');  % online sampling using same seed

% get parameters
mu = options.PopulationSize; % population size
dim = options.Dim; % dimension of the optimization function

opIdx = optionalArgs.opIdx;
mutationType = options.MutationType; % mutation type
crossoverType = options.CrossoverType; % crossover type
F = options.F; % scale factor
CR = options.CR; % crossover rate


% Init several local variables
FEs = 0; % total fitness evaluations
gens = 0; % total number of generations
% bestFitEachGen = zeros(1); % init best fitness values of each generation
% bestXEachGen = cell(1); % init best x of each generation
FEsEachGen = zeros(1); % init number of fitness evaluations of each generation
% bestXSoFar = cell(1); % init best x so far
bestFitSoFar = zeros(1); % init best fitness values so fat

% Init the first generation
[x, fit, ~] = initFstGen(optionalArgs, options, func_names, func_num, opIdx, run_num);

% find the best fitness value and its index
[minFit, bestIdx] = min(fit);
bestFit = minFit;
% find the best individual
% bestX = x(bestIdx, :);
% update local variables
FEs = FEs + mu;
gens = gens + 1;
% bestFitEachGen(gens) = bestFit;
bestFitSoFar(gens) = bestFit;
% bestXEachGen{gens} = bestX;
% bestXSoFar{gens} = bestX;
FEsEachGen(gens) = FEs;
% build a struct array to save inner variables
% variables.FEs = FEs;
% variables.gens = gens;
% save this generation to file
%     saveEachGen(gens, saveGenPath, x, fit, variables);

% do the main loop
while FEs < options.MaxFEs
    
    for i = 1:mu
        % mutation
        vi = mutation(x, i, bestIdx, mutationType, F, fit);
        
        % crossover
        ui = crossover(x(i, :), vi, dim, crossoverType, CR);
        
        % bound constraint
        ui = boundCons(ui, options);
        
        % survival selection
        offFit = benchmark_func(ui, func_num);
        
        if offFit <= fit(i)
            x(i, :) = ui;
            fit(i) = offFit;
        end
    end
    
    % find the best fitness value and its index
    [minFit, bestIdx] = min(fit);
    bestFit = minFit;
    % find the best individual
    %     bestX = x(bestIdx, :);
    % update local variables
    FEs = FEs + mu;
    gens = gens + 1;
    %     bestFitEachGen(gens) = bestFit;
    %     bestXEachGen{gens} = bestX;
    % judge best fitness value so far
    if bestFit < bestFitSoFar(gens-1)
        bestFitSoFar(gens) = bestFit;
        %         bestXSoFar{gens} = bestX;
    else
        bestFitSoFar(gens) = bestFitSoFar(gens-1);
        %         bestXSoFar(gens) = bestXSoFar(gens-1);
    end
    FEsEachGen(gens) = FEs;
    % build a struct array to save inner variables
    %     variables.FEs = FEs;
    %     variables.gens = gens;
    % save this generation to file
    %         saveEachGen(gens, saveGenPath, x, fit, variables);
    
    %     % termination criteria: running mean
    %     window = options.StallGenLimit;  % size of window
    %     if gens >= window + 1
    %         residual = abs(bestFitSoFar(gens) - mean(bestFitSoFar((gens-window):(gens-1))));
    %         if residual <= options.TolFun
    %             break;
    %         end
    %     end
    
    % ignore the last generation if: leftFEs < populationSize
    if options.MaxFEs - FEs < mu
        break;
    end
    
    
end

% save variables to .mat file and plot the convergence curve
bestFitness(bestFitSoFar, FEsEachGen, func_names, func_num, run_num, opIdx, options);

end

