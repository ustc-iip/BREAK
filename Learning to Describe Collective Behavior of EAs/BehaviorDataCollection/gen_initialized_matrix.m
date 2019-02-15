function  initialized_matrix = gen_initialized_matrix( lb, ub, NP, D )
%   Generate NP * D random number matrix whose values are located in [lb, ub]

initialized_matrix = lb + (ub - lb) * rand(NP, D);
%save('initialized_matrix.mat', 'initialized_matrix');

end