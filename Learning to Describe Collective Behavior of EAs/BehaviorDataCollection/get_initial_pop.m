initial_lb = 5;                          % the lower bound of initialization
initial_ub = 10;                         % the upper bound of initialization
NP = 100;                                % size of population
D = 30;                                  % dimension of population

initial_pop = gen_initialized_matrix(initial_lb, initial_ub, NP, D);     % generate the initialized population
% save_initial_pop_path = 'result';
% if ~isdir(save_initial_pop_path)
%     mkdir(save_initial_pop_path);
% end
% save([save_initial_pop_path, filesep, 'initial_pop_', num2str(initial_lb), '_', num2str(initial_ub)],  'initial_pop');
save initial_pop