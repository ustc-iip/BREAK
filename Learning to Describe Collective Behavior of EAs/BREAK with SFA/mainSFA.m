close all; clear; clc;

input_home_train = 'result_train/som_rawdata';
output_home_train = 'result_train/multiSFA';
input_home_test = 'result_test/som_rawdata';
output_home_test = 'result_test/multiSFA';

dirstruct = dir(input_home_train);                     % read input path to get the subfolders
function_name = cell(1);
algorithm_name = cell(1);
for i = 3:length(dirstruct)
    function_name{i-2} = dirstruct(i).name;
end

dirstruct = dir([input_home_train '/' function_name{1}]);
for i = 3:length(dirstruct)
    algorithm_name{i-2} = dirstruct(i).name;
end

for i = 1:length(function_name)                                % read the data of different EAs under the same benchmark function
    function_name_each = function_name{i};
    mkdir([output_home_train, filesep, function_name_each]);
    savePath_train = [output_home_train, filesep, function_name_each];
    mkdir([output_home_test, filesep, function_name_each]);
    savePath_test = [output_home_test, filesep, function_name_each];
    k = 1;
    for j = 1:length(algorithm_name)
        algorithm_name_each = algorithm_name{j};
        load([input_home_train '/' function_name_each '/' algorithm_name_each '/hits']);
        [~, col] = size(hits);
        data_train(:, k:k+col-1) = hits;
        
        load([input_home_test '/' function_name_each '/' algorithm_name_each '/hits']);
        data_test(:, k:k+col-1) = hits;
        
        k = k + col;
    end
    data_input_train = data_train';
    data_input_test = data_test';
    save([savePath_train, filesep, 'data_input_train.mat'], 'data_input_train');
    save([savePath_test, filesep, 'data_input_test.mat'], 'data_input_test');
    dim_PCA = 30;

    [data_PCA_train, data_PCA_test] = PCAofTrainTest(data_input_train, data_input_test, dim_PCA); 
    save([savePath_train, filesep, 'data_PCA_train.mat'], 'data_PCA_train');
    save([savePath_test, filesep, 'data_PCA_test.mat'], 'data_PCA_test');
    [y1_train, hd1] = sfa1(data_PCA_train);
    y1_test = sfa_execute(hd1, data_PCA_test);
    save([savePath_train, filesep, 'y1_train.mat'], 'y1_train');
    save([savePath_test, filesep, 'y1_test.mat'], 'y1_test');
end