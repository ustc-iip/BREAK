function plotConverTrend( FEsEachGen, bestFit, saveFigPath, figName )
% Plot the convergence trend.
%   Parameters:
%   FEsEachGen          - The number of fitness evaluations of each generation
%                       [row vector]
%   bestFit             - The best fitness values, can be bestFitSoFar or bestFitEachGen
%                       [row vector]
%   saveFigPath         - The path to save figure
%                       [positive scalar]
%   figName             - The name of the saved figure
%                       [string]


figure('Visible', 'off');
% semilogy(FEsEachGen, bestFit, 'b');
plot(FEsEachGen, bestFit, 'b');
xlabel('FEs');
% ylabel('$log(f(x)-f(x^*))$', 'interpreter', 'latex');
ylabel('$f(x)-f(x^*)$', 'interpreter', 'latex');
grid on;
print([saveFigPath, filesep, figName], '-depsc');
close;

end

