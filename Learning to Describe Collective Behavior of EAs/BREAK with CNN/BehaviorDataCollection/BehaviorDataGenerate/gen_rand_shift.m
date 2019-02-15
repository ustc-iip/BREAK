function  rand_shift = gen_rand_shift( lb, ub, D )
%   Generate 1 * D random number matrix whose values are located in [lb, ub]

% shift = lb + (ub - lb) * rand(1, D);

% set random shift be same in all dimension
rand_num = lb + (ub - lb) * rand;
rand_shift = repmat(rand_num, 1, D);

save('rand_shift.mat', 'rand_shift');

end

