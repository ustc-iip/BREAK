function options = setOptions( varargin )
% Set initial parameters for all Evolutionary Algorithms.
%   Parameters:
%   varargin            - Variable-length input argument list
%                       [(key, value) argument pairs]
%   General Settings:
%   AlgoName            - The saving name
%                       [ string | 'DE' ]
%   PopInitRange        - Initial range of values a population may have
%                       [ row vector  | [-100, 100] ]
%   Dim                 - Dimension of optimization functions
%                       [ positive scalar | 30 ]
%   MaxFEs              - Maximum number of Fitness Evaluations allowed
%                       [ positive scalar | 10000*Dim]
%   TolFun              - Termination tolerance on fitness value
%                       [ positive scalar | 1e-8 ]
%   Qualitative Parameters of DE:
%   MutationType        - Type of mutation operators
%                       [ string | 'rand_1', 'best_1', 'target-to-best_1'
%                       'best_2', 'rand_2', 'rand_2_dir']
%   CrossoverType       - Type of crossover operators
%                       [ string | 'bin', 'exp']
%   BoundConsType       - Type of bound constraint strategies
%                       [ string | 'absorb', 'random', 'reflect', 'torodal',
%                       'evolutionary']
%   Quantitative Parameters of DE:
%   PopulationSize      - The number of individuals
%                       [ positive scalar | 100 ]
%   F                   - Scale factor
%                       [ double | F is between (0, 1] ]
%   CR                  - Crossover rate
%                       [ double | CR is between (0, 1] ]


% Init default options when no varargin given
if nargin == 0
    options = struct(...
        ... % general settings
        'AlgoName', 'DE', ...
        'PopInitRange', [-100, 100], ...
        'Dim', 30, ...
        'MaxFEs', 1e4*30, ...
        'StallGenLimit', 50, ...
        'TolFun', 1e-8, ...
        ... % qualitative parameters: structural tuning
        'MutationType', 'rand_1', ... % type of mutation operator
        'CrossoverType', 'bin', ...% type of crossover operator
        'BoundConstraint', 'absorb', ... % type of bound constraint strategy
        ... % quantitative parameters: parameter tuning
        'PopulationSize', 100, ... % population size
        'F', 0.5, ... % scale factor
        'CR', 0.9 ... % crossover rate
        );
else
    % Set options, note that the first argument should be options struct
    options = varargin{1};
    for i = 2:2:(nargin-1)
        if isfield(options, varargin{i})
            options.(varargin{i}) = varargin{i+1};
        end
        if strcmp(varargin{i}, 'Dim')
            options = setOptions(options, 'MaxFEs', 1e4*options.Dim);
        end
    end
    if rem(i, 2)
        error('Variable-length input argument need to be odd!');
    end
    
end

end

