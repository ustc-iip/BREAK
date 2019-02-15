function run_data_output_som(Map, inputhome, outputhome, functionname_each, algorithmname_each, num_unit)
%   In order to run data output som using parfor

%dim = 100;

mkdir([outputhome '/' functionname_each '/' algorithmname_each]);
tempnames = getsortnames([inputhome '/' functionname_each '/' algorithmname_each]);            % get the names of raw data
timename =  [functionname_each '/' algorithmname_each];
strload = load([inputhome '/' timename '/' tempnames{1}]);
data = cell(1);
if isfield(strload, 'pop')
    for m = 1:length(tempnames)
        load([inputhome '/' timename '/' tempnames{m}]);
        %data{m} = [pop, val];
         data{m} = pop;
    end
elseif isfield(strload, 'x')
    for m = 1:length(tempnames)
        load([inputhome '/' timename '/'  tempnames{m}]);
        %data{m} = [x, oldval];
        data{m} = x;
    end
elseif isfield(strload, 'foods')
    for m = 1:length(tempnames)
        load([inputhome '/' timename '/' tempnames{m}]);
        %data{m} = [foods, fitness];
        data{m} = foods;
    end
end
templen = length(tempnames);
hits = zeros(num_unit, templen);
for t = 1:templen
     hits(:,t) = gethit(Map, data{t});
end
%[del_rep_data, ia, ~] = unique(hits','rows','stable');
%del_rep_index = tempnames(ia);
%del_rep_data = del_rep_data';
% del_rep_data = hits;
isaves([outputhome '/'  timename], hits);
%isaves([outputhome '/'  timename], del_rep_data, [outputhome '/'  timename], del_rep_index);

%{
% save del_rep_data to mat files
save_file_path = ['../result/som_del_rep_file', filesep, timename];
if ~isdir(save_file_path)
    mkdir(save_file_path);
end
for i = 1:size(del_rep_data, 2)
    each_data = reshape(del_rep_data(:, i), dim, dim);
    each_name = del_rep_index{i};
    save([save_file_path, filesep, each_name], 'each_data');
end
%}

end

