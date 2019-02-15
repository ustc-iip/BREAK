function fit = benchmark_func(x, func_num, shift_flag)
[pop, D] = size(x);

% Shift x
if shift_flag == 1
    load('rand_shift.mat');
    shift = repmat(rand_shift, pop, 1);
    x = x - shift;
end

switch  func_num
    case 1
        % Shifted Sphere Function: search space: [lb,ub], global fmin 0
        fit = sum(x.*x, 2);
    case 2
        % Shifted Elliptic Function: search space: [lb,ub], global fmin 0
        a = 1e+6;
        fit = 0;
        for i = 1:D
            fit = fit + a.^((i-1)/(D-1)).*x(:,i).^2;
        end
    case 3
        % Shifted Rastrigin's Function: search space: [lb,ub], global fmin 0
        fit = sum(x.*x - 10*cos(2*pi*x) + 10, 2);
    case 4
        % Shifted Ackley's Function: search space: [lb,ub], global fmin 0
        fit = sum(x.^2, 2);
        fit = 20 - 20*exp(-0.2*sqrt(fit/D))-exp(sum(cos(2*pi*x),2)/D)+exp(1);
    case 5
        % Shifted Rosenbrock's Function: search space: [lb,ub], global fmin 0
        fit = sum(100.*(x(:,1:D-1).^2 - x(:,2:D)).^2 + (x(:,1:D-1) - 1).^2, 2);
    case 6
        % Shifted Schwefel's Function: search space: [lb,ub], global fmin 0
        fit = 0;
        for i = 1:D
            fit = fit + sum(x(:,1:i),2).^2;
        end
end