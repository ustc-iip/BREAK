function [p, Q, Rm, Rmean, ranked] = f_test(groups)
% Performs a non-parametric one-way
%   ANOVA to test the null hypothesis that independent samples from two or
%   more groups come from distributions with equal medians, and returns the
%   p-value for that test.


[n, k] = size(groups);
ranked = zeros(n, k);

for i = 1: n
    ranked(i, :) = tiedrank(groups(i, :));  % rank each group
end

Rm = sum(ranked, 1);
Rmean = mean(ranked, 1);

% calculate Q
Q = (k - 1) * sum((Rm - n * (k + 1) / 2).^2) ./ (sum(sum(ranked.^2)) - n * k * (k + 1).^2 / 4);

% calculate p-value
df = k-1;
p = 1 - chi2cdf(Q, df);
