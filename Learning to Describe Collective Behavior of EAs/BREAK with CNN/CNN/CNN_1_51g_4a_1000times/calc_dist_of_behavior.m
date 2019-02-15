% analysize_outputFeature_of_different_layer
clear
%close all;
rootDir='../../BehaviorDataCollection/BehaviorData_for_analysis/CNN_1_2g_4a_10000times_withoutdiff/';
Algrithms={'CEP','DE','ES','GA'};
Landscapes = {...
    'Sphere', 'Schwefel12', 'RotatedElliptic', 'Schwefel12withNoise', 'Schwefel2.6',... % Unimodal Function
    'Rosenbrock', 'RotatedGriewank', 'RotatedAckley', 'Rastrigin', 'RotatedRastrigin',...
    'RotatedWeierstrass', 'Schwefel213',...                                             % Multimodal Function Basic Function
    'GriewankPlusRosenbrock', 'RotatedScaffe',...                                       % Expanded Function
    'HybridFunction1', 'RotatedHybridFunction1', 'RotatedHybridFunction1withNoise',...
    'RotatedHybridFunction2', 'RotatedHybridFunction1NarrowBasin', 'RotatedHybridFunction1onBounds',...
    'RotatedHybridFunction3', 'RotatedHybridFunction1withCondition', 'NonContinuousRotatedHybridFunction3',...
    'RotatedHybridFunction4', 'RotatedHybridFunction1withoutBounds'...                  % Hybrid Composition Function
    };

length_algs=4;
n_alg=3000;      %samples_of_each_alg

%% get network
file=ls(['all_net/*.mat']);       % obtain full directory of the file
if  length(file)>50
    Tmp=split(file,' ');
    load(char(Tmp(1)));
else
    load(file(1:end-1));
end

%% calculate distance
for L=[1:10,14]
    fprintf('Loding xTest_cnn...\n ');
    load([rootDir Landscapes{L} '/' 'xTest_cnn.mat']);
    load([rootDir Landscapes{L} '/' 'yTest_cnn.mat']);
    label=int8(yTest_cnn);
    saveDir=[Landscapes{L} '/' 'visualization_result_2D/'];
    if ~exist(saveDir)
        mkdir(saveDir);
    end
    [~,~,~,num]=size(xTest_cnn);
    %index=randperm(num);
    % traversal feature layer 7 to10
    for i=[10]
        outputFeatures = activations(net,xTest_cnn,i);     % extract output of the specify layer
        c1=mean(outputFeatures(1:n_alg,:));
        c2=mean(outputFeatures(n_alg+1:n_alg*2,:));
        c3=mean(outputFeatures(n_alg*2+1:n_alg*3,:));
        c4=mean(outputFeatures(n_alg*3+1:n_alg*4,:));
        m=[ c1',c2',c3',c4']';
        % compute euclidean distance
        dist_norm2=pdist(m,'euclidean')
        % compute cosine distance
        dist_conosine=pdist(m,'cosine')
    end
end