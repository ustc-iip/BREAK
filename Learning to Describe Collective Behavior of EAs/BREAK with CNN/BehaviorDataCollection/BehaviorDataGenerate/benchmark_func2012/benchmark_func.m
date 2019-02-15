
%INPUTS:
% x:       the decision vector to the objective function in form of a column vector
%          it can also be a matrix where each column represent a decision vector.
%
%func_num: the index of the objective function to be evaluated ranging [1,15].
%
%return:   the objective value the specified objective function for the give decision vector.


function fit = benchmark_func(x, func_num, ~)
fit = benchmark2012(x', func_num);
end

