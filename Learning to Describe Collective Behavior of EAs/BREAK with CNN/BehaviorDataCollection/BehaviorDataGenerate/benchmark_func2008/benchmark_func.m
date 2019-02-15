function f=benchmark_func(x,func_num, ~)

persistent funcNum fhd f_bias fitptr fiter

if isempty(funcNum) || funcNum ~= func_num
    if func_num==1      fhd=str2func('sphere_shift_func'); %[-100,100]
    elseif func_num==2  fhd=str2func('schwefel_func'); %[-100, 100]
    elseif func_num==3  fhd=str2func('rosenbrock_shift_func'); %[-100,100]
    elseif func_num==4  fhd=str2func('rastrigin_shift_func'); %[-5,5]
    elseif func_num==5  fhd=str2func('griewank_shift_func'); %[-600,600]
    elseif func_num==6  fhd=str2func('ackley_shift_func'); %[-32,32]
    elseif func_num==7  fhd=str2func('fastfractal_doubledip'); %[-1,1]    
    end
    funcNum = func_num;
    %f_bias = [-450 -450 390 -330 -180 -140 0];
    load fbias_data;
end
if ~libisloaded('benchmark2008')
    loadlibrary('benchmark2008');
end
[ps, D] = size(x);
x = reshape(x', ps * D, 1);
if isempty(fiter) || size(fiter, 1) < ps
    fiter = zeros(ps, 1);
    fitptr = libpointer('doublePtr', fiter);
end

f=feval(fhd, x, fitptr, ps, D);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Unimodal%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	1.Shifted Sphere Function 
function fit=sphere_shift_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Shifted_Sphere', fitptr, x, ps, D);
fit = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
% persistent o
% [ps,D]=size(x);
%     if isempty(o)
%     load sphere_shift_func_data
%     if length(o)>=D
%          o=o(1:D);
%     else
%          o=-100+200*rand(1,D);
%     end
%     
% end
% x=x-repmat(o,ps,1);
% fit=sum(x.^2,2);
% err = fit - fit1
end




% 2. Shifted Schwefel's Problem 2.21
function fit = schwefel_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Schwefel_Problem', fitptr, x, ps, D);
fit = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
%    persistent o
%    [ps, D] = size(x);
%    if isempty(o)
%       load schwefel_shift_func_data
%       if length(o) >= D
%           o=o(1:D);
%       else
%           o=-100+200*rand(1,D);
%       end
%    end
%    x=x-repmat(o,ps,1);
%    fit = max(abs(x), [], 2);
%    err = fit - fit1
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Multimodal%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	3.Shifted Rosenbrock's Function
function f=rosenbrock_shift_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Shifted_Rosenbrock', fitptr, x, ps, D);
f = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
% persistent o
% [ps,D]=size(x);
% if isempty(o)
%     load rosenbrock_shift_func_data
%     if length(o)>=D
%          o=o(1:D);
%     else
%          o=-90+180*rand(1,D);
%     end
%     
% end
% x=x-repmat(o,ps,1)+1;
% f=sum((100.*(x(:,1:D-1).^2-x(:,2:D)).^2+(x(:,1:D-1)-1).^2),2);
% err = f - fit1
end
% 4.Shifted Rastrign's Function
function f=rastrigin_shift_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Shifted_Rastrigin', fitptr, x, ps, D);
f = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
% persistent o
% [ps,D]=size(x);
% if isempty(o)
%     load rastrigin_shift_func_data
%     if length(o)>=D
%          o=o(1:D);
%     else
%          o=-5+10*rand(1,D);
%     end
%     
% end
% x=x-repmat(o,ps,1);
% f=sum(x.^2-10.*cos(2.*pi.*x)+10,2);
% err = f - fit1
end
% 5.Shifted Griewank's Function
function f=griewank_shift_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Shifted_Griewank', fitptr, x, ps, D);
f = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
% persistent o
% [ps,D]=size(x);
% if isempty(o)
%     load griewank_shift_func_data
%     if length(o)>=D
%          o=o(1:D);
%     else
%          o=-600+1200*rand(1,D);
%     end
%     o=o(1:D);
%     
% end
% x=x-repmat(o,ps,1);
% f=1;
% for i=1:D
%     f=f.*cos(x(:,i)./sqrt(i));
% end
% f=sum(x.^2,2)./4000-f+1;
% err  = f - fit1
end
% 	6.Shifted Ackley's Function
function f=ackley_shift_func(x, fitptr, ps, D)
calllib('benchmark2008', 'Shifted_Ackley', fitptr, x, ps, D);
f = fitptr.Value(1:ps);
% x = reshape(x, D, ps)';
% persistent o
% [ps,D]=size(x);
% if isempty(o)
%     load ackley_shift_func_data
%     if length(o)>=D
%          o=o(1:D);
%     else
%          o=-30+60*rand(1,D);
%     end
%     
% end
% x=x-repmat(o,ps,1);
% f=sum(x.^2,2);
% f=20-20.*exp(-0.2.*sqrt(f./D))-exp(sum(cos(2.*pi.*x),2)./D)+exp(1);
% err = f - fit1
end
%   7. FastFractal "DoubleDip"
function f=fastfractal_doubledip(x, fitptr, ps, D)

persistent o ff
[ps,D]=size(x);
if isempty(o)
    load fastfractal_doubledip_data
    ff = FastFractal('DoubleDip', 3, 1, o, D);
    
end
f=ff.evaluate(x);
end
%%%%% end of file %%%%%

