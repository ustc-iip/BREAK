% function function_plot
% clear;close all
% Xmin=[-100,-100,-100,-100,-100,-100,0,-32,-5,-5,-0.5,-pi,-3,-100,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,2];
% Xmax=[100,100,100,100,100,100,600,32,5,5,0.5,pi,1,100,5,5,5,5,5,5,5,5,5,5,5];

function fhead = func_plot(func_num)
range = [-100, -5, -32, -100, -5, -32, -100, -100, -5, -32, -100, -100, -100, -100, -100
        100,  5,  32,  100,  5,  32,  100,  100,  5,  32,  100,  100,  100,  100,  100];
x = linspace(range(1, func_num), range(2, func_num), 100);
y = x;

[X, Y] = meshgrid(x, y);
xx = reshape(X, length(x) ^ 2, 1);
yy = reshape(Y, length(y) ^ 2, 1);
f = benchmark_func([xx, yy], func_num);
f = reshape(f, length(x), length(x));

figure
fhead = surfc(Y,X,f);
end


