%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Collect the Behavior Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lb = -100;         % bound
ub = 100;
NP = 100;         % population size
D = 30;           % dimensionality of benchmark functions
runs = 500;        % number of running
maxFEs = NP*2;     % the maximum of fitness evaluation
shift_flag = 0;           % the flag to decide whether or not add a shift value to benchmark functions
if shift_flag == 1
    rand_shift = gen_rand_shift(lb, ub, D);
end

save_func_name = {'Sphere', 'Elliptic', 'Rastrigin', 'Ackley', 'Rosenbrock', 'Schwefel'};     % benchmark functions name

shift_len = -7.5;                             % using the offset to change the landscape of the initial population
load initial_pop
initial_pop = initial_pop + shift_len;

for func_num = 1:6
    CEP(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag);
    DE(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag);
    ES(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag);
    GA(save_func_name, func_num, maxFEs, initial_pop, lb, ub, NP, D, runs, shift_flag);
end
