clear,clc

dirstruct = dir('result_train/multiSFA');
function_name = cell(1);
for i = 3:length(dirstruct)
    function_name{i-2} = dirstruct(i).name;
end

for j = 1:length(function_name)
    function_name_each = function_name{j};
    load(['result_train/multiSFA', filesep, function_name_each, filesep, 'y2_train.mat']);
    featureData = y2_train;
    figure(j)
    scatter(featureData(1:500, 1), featureData(1:500, 2), '*k');
    hold on;
    scatter(featureData(501:1000, 1), featureData(501:1000, 2), 'or', 'filled');
    hold on;
    scatter(featureData(1001:1500, 1), featureData(1001:1500, 2), 's', 'MarkerEdgeColor', [0 0.6 0.6], 'MarkerFaceColor', [0 0.6 0.6]);
    hold on;
    scatter(featureData(1501:2000, 1), featureData(1501:2000, 2), '^b', 'filled');
    hold on;
    
    xlabel('feature1');
    ylabel('feature2');
    legend('CEP', 'DE', 'ES', 'GA');
    title(function_name_each);
end