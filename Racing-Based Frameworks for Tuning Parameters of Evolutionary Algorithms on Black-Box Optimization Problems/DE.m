function DE( run_num, func_names, func_num, options, optionalArgs )
% Framework for Differential Evolution (DE/x/y/z).
% General scheme of EAs:
% 1. Decide a genetic representation of a candidate solution to the
%    problem, including define the genotype and the mapping/function from
%    genotype to phenotype;
% 2. Initialise the parameters.
% 3. Initialise the first generation with a population of candidate
%    solutions;
% 4. Evaluate each candidate in the first generation;
% 5. Parent selection (optional, fitness scaling may be necessary before
%    certain selection);
% 6. Recombine pairs of parents (maybe after 7);
% 7. Mutate the resulting individual;
% 8. Evaluate new candidates;
% 9. Survival selection;
% 10. Goto 5, and Loop until termination condition is satisfied;
% 11. Goto 1. and Loop if want to run several times.

%   Parameters:
%   runStart            - start run number
%                       [positive scalar]
%   runEnd              - end run number
%                       [positive scalar]
%   func_names          - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
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

% persistent f_bias
% % load funtion bias
% if isempty(f_bias)
%     fbiasStr = load('fbias_data');
%     f_bias = fbiasStr.f_bias;0
% end

% perform core
DE_core(run_num, func_names, func_num, options, optionalArgs);

end

