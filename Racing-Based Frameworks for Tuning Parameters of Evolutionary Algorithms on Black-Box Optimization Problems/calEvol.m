function calEvol( run_num_normal, func_names, func_num, opIdx, options )
% Calculate the features of population evolvability.
%   Parameters:
%   runNumNormal        - The number of normal runs
%                       [positive scalar]
%   func_names          - Function names
%                       [cell array of strings]
%   func_num            - The number of optimization functions
%                       [positive scalar]
%   options             - The options set by setOptions()
%                       [struct array]


% path of sampled data
readSamPath = ['result', filesep, 'raw_data', filesep, 'dim_', num2str(options.Dim),...
    filesep, func_names{func_num}, filesep, options.AlgoName, filesep, 'onlineSampling'];

% get all file names sorted by integer
names = getSortNames(readSamPath); % note that it's a cell array of sorted names by integer
% number of sampled population, ignore the last generation
nSamPop = length(names) - 1;

% generate T neighbours on sampled population
% such as: T = 10, stepSize = 10
nNeighbours = 5;
stepSize = 5;
for fstNum = 1:stepSize:nSamPop
    % load .mat data
    fileStr = load([readSamPath, filesep, names{fstNum}, '.mat']);
    % load x and fit
    popEach = fileStr.x;
    fitEach = fileStr.fit;
    % init the struct array optionalArgs
    optionalArgs.InitPopulation = popEach;
    optionalArgs.InitFitness = fitEach;
    optionalArgs.opIdx = opIdx;
    optionalArgs.fst_num = fstNum;
    optionalArgs.run_num_normal = run_num_normal;
    optionalArgs.nNeighbours = nNeighbours;
    % load variables
    optionalArgs.variables = fileStr.variables;
    % run an EA to calculate the features of evolvability
    feval(options.AlgoName, 1, nNeighbours, func_names, func_num, options, optionalArgs);
end


end
