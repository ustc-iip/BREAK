
%INPUTS:
% x:       the decision vector to the objective function in form of a column vector
%          it can also be a matrix where each column represent a decision vector.
%
%func_num: the index of the objective function to be evaluated ranging [1,15].
%
%return:   the objective value the specified objective function for the give decision vector.


function fit = benchmark_func(x, func_num, ~)

% persistent fnum fhd
% 
% if (isempty(fnum) || fnum~= func_num)
%     fnum = func_num;
%     % 1. Fully-separable Functions
%     if     (func_num ==  1) fhd = str2func('f1');
%     elseif (func_num ==  2) fhd = str2func('f2');
%     elseif (func_num ==  3) fhd = str2func('f3');
%         % 2. Partially Additively Separable Functions
%         %    2.1. Functions with a separable subcomponent:
%     elseif (func_num ==  4) fhd = str2func('f4');
%     elseif (func_num ==  5) fhd = str2func('f5');
%     elseif (func_num ==  6) fhd = str2func('f6');
%     elseif (func_num ==  7) fhd = str2func('f7');
%         %    2.2. Functions with no separable subcomponents:
%     elseif (func_num ==  8) fhd = str2func('f8');
%     elseif (func_num ==  9) fhd = str2func('f9');
%     elseif (func_num == 10) fhd = str2func('f10');
%     elseif (func_num == 11) fhd = str2func('f11');
%         %3. Overlapping Functions
%     elseif (func_num == 12) fhd = str2func('f12');
%     elseif (func_num == 13) fhd = str2func('f13');
%     elseif (func_num == 14) fhd = str2func('f14');
%         % 4. Fully Non-separable Functions
%     elseif (func_num == 15) fhd = str2func('f15');
%     end
%     
% end
% 
% fit = feval(fhd, x);

fit = benchmark2013(x', func_num);
end

