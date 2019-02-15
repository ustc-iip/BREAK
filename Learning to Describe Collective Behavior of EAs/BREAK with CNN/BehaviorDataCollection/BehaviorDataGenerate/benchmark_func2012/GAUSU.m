function [pop, value, FEs] = GAUSU(pop, value, func_num, NP, D, ini_flag, inilb, iniub, lb, ub)
p_crossover = 0.9; % crossover rate
p_mutation = 0.01; % mutation rate
nXoverKids = 2 * round(p_crossover * NP / 2); % number of kids which will survived to next generation
nParents = NP;           % number of parents for mutation and crossover

% selection uniform
parents = randi(size(pop, 1), nParents, 1);

parents = parents(randperm(length(parents)));
parents1 = parents(1:(nXoverKids/2));
parents2 = parents(((nXoverKids/2) + 1):(nXoverKids));


% crossover simple
xoverKids = zeros(NP, D);
selDim = randi((D - 1), NP, 1);
xoverKids(1:(nXoverKids/2), :) = [pop(parents1, 1:selDim), pop(parents2, (selDim + 1):end)];
xoverKids(((nXoverKids/2) + 1):(nXoverKids), :) = [pop(parents2, 1:selDim), pop(parents1, (selDim + 1):end)];
xoverKids = min(ub, max(lb, xoverKids));
xoverKids((nXoverKids):end, :) = pop(parents(nXoverKids:end), :);

% mutation uniform
mutation_matrix = rand(size(xoverKids));
ind = find(mutation_matrix < p_mutation);
%     xoverKids(ind) = inilb + (iniub - inilb) .* rand(1, length(ind));
xoverKids(ind) = inilb + (iniub - inilb) * rand(size(ind));
xoverKids = min(ub, max(lb, xoverKids));
% evaluate
pop =  xoverKids;
value = benchmark_func(pop, func_num);
FEs = NP;
end