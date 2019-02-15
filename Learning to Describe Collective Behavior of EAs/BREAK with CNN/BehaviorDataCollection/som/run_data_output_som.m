function run_data_output_som(Map, inputhome, outputhome, functionname_each, algorithmname_each, run_time_each,num_unit)
%   In order to run data output som using parfor
% dim = 100;

mkdir([outputhome '/' functionname_each '/' algorithmname_each '/' run_time_each ]);
tempnames = getsortnames([inputhome '/' functionname_each '/' algorithmname_each '/' run_time_each]);            % get the names of raw data
timename =  [functionname_each '/' algorithmname_each '/' run_time_each];
strload = load([inputhome '/' timename '/' tempnames{1}]);
data = cell(1);

templen=2;
if isfield(strload, 'pop')
    for m = 1:templen
        load([inputhome '/' timename '/' tempnames{m}]);
        %data{m} = [pop, val];
         data{m} = pop;
    end
elseif isfield(strload, 'x')
    for m = 1:templen
        load([inputhome '/' timename '/'  tempnames{m}]);
        %data{m} = [x, oldval];
        data{m} = x;
    end
elseif isfield(strload, 'foods')
    for m = 1:templen
        load([inputhome '/' timename '/' tempnames{m}]);
        %data{m} = [foods, fitness];
        data{m} = foods;
    end
end
% templen = length(tempnames);
%%
    templen=2;
%%
hits = zeros(num_unit, templen);
parfor t = 1:templen
     hits(:,t) = gethit(Map, data{t});
end
hits=int8(hits);
isaves([outputhome '/'  timename], hits);

%% process distribution of SOM with rescale
source_data=[];
source_data=data;
%templen = templen;
hits = zeros(num_unit, templen);
diff_hits = zeros(num_unit, templen-1);
hits(:,1) = gethit(Map, data{1});
[rows,cols]=size(data{1});
templen=2;
for t = 2:templen
     x_max=max(max(max(source_data{t-1})),max(max(source_data{t})));
     x_min=min(min(min(source_data{t-1})),min(min(source_data{t})));
     for i=1:rows
         for j=1:cols
             data{t-1}(i,j)=((source_data{t-1}(i,j)-x_min)./(x_max-x_min)-0.5)*64;
             data{t}(i,j)=((source_data{t}(i,j)-x_min)./(x_max-x_min)-0.5)*64;
         end
     end
     hits(:,t-1) = gethit(Map, data{t-1});
     hits(:,t) = gethit(Map, data{t});
     diff_hits(:,t-1)= hits(:,t)-hits(:,t-1);
end
diff_hits=int8(diff_hits);
save([outputhome '/'  timename '/' 'diff_hits'], 'diff_hits');
%[del_rep_data, ia, ~] = unique(hits','rows','stable');
%del_rep_index = tempnames(ia);
%del_rep_data = del_rep_data';
% del_rep_data = hits;

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

