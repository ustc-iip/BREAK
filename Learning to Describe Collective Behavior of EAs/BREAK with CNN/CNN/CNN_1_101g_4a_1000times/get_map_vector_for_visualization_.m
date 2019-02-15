clear
clc
rootDir='../../BehaviorDataCollection/BehaviorData_for_analysis/CNN_1_2g_4a_1000times_withoutdiff/all_testFunction/';
Algrithms={'CEP','DE','ES','GA'};
length_algs=4;
fig_num=0;      % count save number value of figure

load([rootDir  '/' 'xTrain.mat']);
load([rootDir  '/'  'yTrain.mat']);
load([rootDir  '/' 'xTest.mat']);
load([rootDir  '/'  'yTest.mat']);
load('all_net_3/net_95.3831_20.mat');
saveDir='PCAma_V_1_2';
if ~exist(saveDir)
    mkdir(saveDir)
end
length_layers=length(net.Layers);
for i=[length_layers-4,length_layers-3]
        outputFeatures = activations(net,xTest,i);     % extract output of the specify layer
        V=[];
        D=[];
        % [Feature_PCA,V,D]=mypca(outputFeatures,2);
        [Feature_PCA,V,D]=mypca_2(outputFeatures,2);
        save([saveDir '/' 'V_' num2str(i)  '.mat'],'V','-v7.3');
end




