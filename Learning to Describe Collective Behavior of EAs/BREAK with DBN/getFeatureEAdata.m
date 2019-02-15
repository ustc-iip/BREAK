%Test getFeature function for autoEncoder DBN in MNIST data set
clc
clear all;
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
%data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
data = EAdata.prepareEAdata_som_20170309('+EAdata\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

dbn=DBN();
dbn.dbnType='autoEncoder';
%
% RBM1
rbmParams=RbmParameters(5000,ValueType.binary);
rbmParams.maxEpoch=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%
% RBM2
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.maxEpoch=5;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%
% RBM3
rbmParams=RbmParameters(30,ValueType.gaussian);
rbmParams.maxEpoch=50;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%
% RBM4
rbmParams=RbmParameters(60,ValueType.gaussian);
rbmParams.maxEpoch=5;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%
% RBM5
rbmParams=RbmParameters(30,ValueType.gaussian);
rbmParams.maxEpoch=50;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%}
% RBM6
rbmParams=RbmParameters(15,ValueType.gaussian);
rbmParams.maxEpoch=50;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.Gibbs;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%}
% RBM7
rbmParams=RbmParameters(3,ValueType.gaussian);
rbmParams.maxEpoch=50;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.Gibbs;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
figure(1);
i = 0;
img=data.testData(data.testLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), '*k');
hold on;
i = 1;
img=data.testData(data.testLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), 'or', 'filled');
%scatter3(ext(:,1),ext(:,2), ext(:,3), 'or');
hold on;
i = 2;
img=data.testData(data.testLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3),  's', 'MarkerEdgeColor', [0 0.6 0.6], 'MarkerFaceColor', [0 0.6 0.6]);
%scatter3(ext(:,1),ext(:,2), ext(:,3),  's', 'MarkerEdgeColor', [0 0.6 0.6]);
hold on;
i = 3;
img=data.testData(data.testLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), '^b', 'filled');
%scatter3(ext(:,1),ext(:,2), ext(:,3), '^b');
hold on;
legend('CEP','DE','ES','GA');
title('before BP(test)');
hold off;

figure(2);
i = 0;
img=data.trainData(data.trainLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), '*k');
hold on;
i = 1;
img=data.trainData(data.trainLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), 'or', 'filled');
%scatter3(ext(:,1),ext(:,2), ext(:,3), 'or');
hold on;
i = 2;
img=data.trainData(data.trainLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3),  's', 'MarkerEdgeColor', [0 0.6 0.6], 'MarkerFaceColor', [0 0.6 0.6]);
%scatter3(ext(:,1),ext(:,2), ext(:,3),  's', 'MarkerEdgeColor', [0 0.6 0.6]);
hold on;
i = 3;
img=data.trainData(data.trainLabels==i,:);
ext=dbn.getFeature(img);
scatter3(ext(:,1),ext(:,2), ext(:,3), '^b', 'filled');
%scatter3(ext(:,1),ext(:,2), ext(:,3), '^b');
hold on;
legend('CEP','DE','ES','GA');
title('before BP(train)');
hold off;
