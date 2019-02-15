% function function_plot
% clear;close all
% Xmin=[-100,-100,-100,-100,-100,-100,0,-32,-5,-5,-0.5,-pi,-3,-100,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,2];
% Xmax=[100,100,100,100,100,100,600,32,5,5,0.5,pi,1,100,5,5,5,5,5,5,5,5,5,5,5];

function fhead = func_plot(func_num)
if func_num==1 x=-100:5:100;y=x; %[-100,100]
elseif func_num==2 x=-100:5:100; y=x;%[-10,10]
elseif func_num==3 x=-100:5:100; y=x;%[-100,100]
elseif func_num==4 x=-100:2:0; y=x+100;%[-100,100]
elseif func_num==5 x=-200:20:200;y=x; %[-5,5]
elseif func_num==6 x=78:0.05:82; y=-51.3:0.05:-47.3;%[-3,1]
elseif func_num==7 x=-450:2:-150; y=-200:2:100;%[-600,600]
elseif func_num==8 x=-5:0.1:5; y=x;%[-32,32]
elseif func_num==9 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==10 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==11 x=-0.5:0.01:0.5; y=x;%[-0.5,0.5]
elseif func_num==12 x=-3:0.1:3; y=x;%[-pi,pi]
elseif func_num==13 x=-2:0.02:-1; y=x;%[-3,1]
elseif func_num==14 x=-5:0.1:5; y=x;%[-100,100]
elseif func_num==15 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==16 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==17 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==18 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==19 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==20 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==21 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==22 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==23 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==24 x=-5:0.1:5; y=x;%[-5,5]
elseif func_num==25 x=-5:0.1:5; y=x;%[-5,5]
end

[X, Y] = meshgrid(x, y);
xx = reshape(X, length(x) ^ 2, 1);
yy = reshape(Y, length(y) ^ 2, 1);
f = benchmark_func([xx, yy], func_num);
f = reshape(f, length(x), length(x));

figure
fhead = surfc(Y,X,f);
end


