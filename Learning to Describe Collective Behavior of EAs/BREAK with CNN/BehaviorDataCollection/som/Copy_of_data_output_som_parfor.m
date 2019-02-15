close all; clear; clc;
load('100_100/map/Map100_finetune.mat');
num_unit = prod(Map.map_size);

outputhome = '../result/som_rawdata100';
inputhome = '../result/raw_data';

dirstruct = dir(inputhome);
functionname = cell(1);
algorithmname = cell(1);
run_timenames=cell(1);
% for i = 3:length(dirstruct)
%     functionname{i-2} = dirstruct(i).name;
% end
functionname={...
    'Sphere', 'Schwefel12', 'RotatedElliptic', 'Schwefel12withNoise', 'Schwefel2.6',... % Unimodal Function
    'Rosenbrock', 'RotatedGriewank', 'RotatedAckley', 'Rastrigin', 'RotatedRastrigin',...
    'RotatedWeierstrass', 'Schwefel213',...                                             % Multimodal Function Basic Function
    'GriewankPlusRosenbrock', 'RotatedScaffe',...                                       % Expanded Function
    'HybridFunction1', 'RotatedHybridFunction1', 'RotatedHybridFunction1withNoise',...
    'RotatedHybridFunction2', 'RotatedHybridFunction1NarrowBasin', 'RotatedHybridFunction1onBounds',...
    'RotatedHybridFunction3', 'RotatedHybridFunction1withCondition', 'NonContinuousRotatedHybridFunction3',...
    'RotatedHybridFunction4', 'RotatedHybridFunction1withoutBounds'...                  % Hybrid Composition Function
    };
dirstruct = dir([inputhome '/' functionname{1}]);
for i = 3:length(dirstruct)
    algorithmname{i-2} = dirstruct(i).name;
end

run_times = dir([inputhome '/' functionname{1} '/' algorithmname{1}]);
for i = 3:length(run_times)
    run_timenames{i-2} = run_times(i).name;
end

% w = 1;
for i =  [1,2,3,6,8,9]          %[1:10,14]                  %  [1,2,5,6,7,9]         %1:length(functionname)
    functionname_each = functionname{i};
    for j =1:length(algorithmname)       %1:length(algorithmname)
        algorithmname_each = algorithmname{j};
       parfor k=   1: length(run_timenames)
            run_times_each=['run_' num2str(k)];
            Copy_of_run_data_output_som(Map, inputhome, outputhome, functionname_each, algorithmname_each,run_times_each,num_unit);
       end
        fprintf([ 'functionname:  '     num2str(i)  '    '    'algorithmname:  '   num2str(j)  ' \n\n\n\n'  ]  )
    end
    delete(gcp);
end

% for i = 1:length(functionname)
% 	for j = 1:length(algorithmname)
% 		for k = 1:length(runname)
% 			mkdir([outputhome '/' functionname{i} '/' algorithmname{j} '/' runname{k}]);
%             tempnames = getsortnames([inputhome '/' functionname{i} '/' algorithmname{j} '/' runname{k}]);            % get the names of raw data
%             timename2{w} = tempnames;
% 			timename{w} =  [functionname{i} '/' algorithmname{j} '/' runname{k}];
%             strload = load([inputhome '/' functionname{i} '/' algorithmname{j} '/' runname{k} '/' tempnames{1}]);
%              if isfield(strload, 'pop')
%                	for m = 1:length(tempnames)
%                     load([inputhome '/' timename{w} '/' timename2{w}{m}]);
%                     data{w}{m} = pop;
%                 end
%              elseif isfield(strload, 'x')
%                  for m = 1:length(tempnames)
%                     load([inputhome '/' timename{w} '/'  timename2{w}{m}]);
%                     data{w}{m} = x;
%                 end
%              elseif isfield(strload, 'foods')
%                  for m = 1:length(tempnames)
%                     load([inputhome '/' timename{w} '/' timename2{w}{m}]);
%                     data{w}{m} = foods;
%                 end
%              end
%             w = w+1;
% 		end
% 	end
% end

% parpool(24)
% parfor t = 1:length(timename)
%     templen = length(timename2{t});
%     %hits = zeros(num_unit, templen);
%     for i = 1:templen
%         hits(:,i) = gethit(Map, data{t}{i});
%     end
%
%     [del_rep_data,ia,~] = unique(hits','rows','stable');
%     del_rep_index = timename2{t}(ia);
%    % where = char(regexp(timename{t}{1}, '\w*/\w*/\w*', 'match'));
%     %mkdir([outputhome '/' where]);
% 	isaves([outputhome '/'  timename{t}], del_rep_data', [outputhome '/'  timename{t}], del_rep_index);
% end
% delete(gcp('nocreate'));
%matlabpool local;
%for i = 1:length(functionname)
%	for j = 1:length(algorithmname)
%		%for k = 1:length(runname)
%		for k = 1:10
%			mkdir([outputhome '/' functionname{i} '/' algorithmname{j} '/' runname{k}]);
%			dirstruct = dir(['raw_data' functionname{1} algorithmname{1}]);
%			for m = 3:length(dirstruct)
%				timename = dirstruct(m).name;
%				load(['raw_data' '/'  functionname{i} '/' algorithmname{j} '/' runname{k} '/' timename]);
%				hit = gethit(Map, Origindata);
%				saves([outputhome '/' functionname{i} '/' algorithmname{j} '/' runname{k} timename '.mat'], 'hit');
%			end
%		end
%	end
%end
