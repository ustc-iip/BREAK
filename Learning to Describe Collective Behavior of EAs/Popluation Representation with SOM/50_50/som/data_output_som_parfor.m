close all; clear; clc;
load('map/Map100_finetune.mat');
num_unit = prod(Map.map_size);

outputhome = '../result/som_rawdata';
inputhome = '../result/raw_data';

dirstruct = dir(inputhome);
functionname = cell(1);
algorithmname = cell(1);
for i = 3:length(dirstruct)
    functionname{i-2} = dirstruct(i).name;
end

dirstruct = dir([inputhome '/' functionname{1}]);
for i = 3:length(dirstruct)
    algorithmname{i-2} = dirstruct(i).name;
end

% w = 1;
for i = 1:length(functionname)
    functionname_each = functionname{i};
    parfor j = 1:length(algorithmname)
        algorithmname_each = algorithmname{j};
            run_data_output_som(Map, inputhome, outputhome, functionname_each, algorithmname_each, num_unit);
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
