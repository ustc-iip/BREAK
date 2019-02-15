% train a CNN
% 'CEP','DE','ES','GA'
clear
clc
rootDir='data_for_demo/CNN_1_2g_4a_10000times/all_testFunction';
Algrithms={'CEP','DE','ES','GA'};
length_algs=4;
fig_num=0;      % count save number value of figure
load([rootDir  '/' 'xTrain.mat']);
load([rootDir  '/'  'yTrain.mat']);
load([rootDir  '/' 'xTest.mat']);
load([rootDir  '/'  'yTest.mat']);
saveDir=['CNN_model/'];
if ~exist(saveDir)
    mkdir(saveDir)
end
% index=find(sum(sum(abs(xTrain)))==0|sum(sum(abs(xTrain)))==2);
% xTrain(:,:,:,index)=[];
% [d1,d2,d3,d4]=size(xTrain);
% yTrain(index)=[];
%% Construct the convolutional neural network architecture.
layers = [imageInputLayer([100 100 1],'Normalization','none');
    convolution2dLayer(5,25);
    reluLayer();
    maxPooling2dLayer(2,'Stride',2);
    convolution2dLayer(3,16);
    reluLayer();
    maxPooling2dLayer(2,'Stride',2);
    fullyConnectedLayer(1024);
    reluLayer();
    fullyConnectedLayer(256);
    fullyConnectedLayer(length_algs);
    softmaxLayer();
    classificationLayer()];
%Set the options to default settings for the stocfnthastic gradient descent with momentum.
for it=5
    opts = trainingOptions('sgdm','MaxEpochs', it,'MiniBatchSize',256);
    %Train the network.
    tic
    net = trainNetwork(xTrain,yTrain,layers,opts);
    toc
    %% Manually compute the train overall accuracy.
    it
    trainPredictions_cnn = classify(net,xTest);
    accuracy_Train = sum(yTest == trainPredictions_cnn)/numel(yTest)
    ytrain= dummyvar(double(yTest))'; % dummyvar requires Statistics and Machine Learning Toolbox
    ypredictions = dummyvar(double(trainPredictions_cnn))';
    figure()
    plotconfusion(ytrain,ypredictions);
    save([ saveDir '/' 'net_' num2str(accuracy_Train*100) '_'  num2str(it)   '.mat'],'net');
    fig_num=fig_num+1;
    print(1,'-dtiff',[saveDir '/' 'confusion_maxtrix'  '_'  num2str(it) '.tif']);
    savefig(1,[saveDir '/' 'confusion_maxtrix'  '_'  num2str(it) '.fig']);
    close all;
    %clear('net');
end
for t=1:5
    opts = trainingOptions('sgdm','MaxEpochs', 5,'MiniBatchSize',512);
    %Train the network.
    tic
    net = trainNetwork(xTrain,yTrain,net.Layers,opts);
    toc
    %% Manually compute the train overall accuracy.
    t
    trainPredictions_cnn = classify(net,xTest);
    accuracy_Train = sum(yTest == trainPredictions_cnn)/numel(yTest)
    ytrain= dummyvar(double(yTest))'; % dummyvar requires Statistics and Machine Learning Toolbox
    ypredictions = dummyvar(double(trainPredictions_cnn))';
    figure()
    plotconfusion(ytrain,ypredictions);
    save([ saveDir '/' 'net_' num2str(accuracy_Train*100) '_'  num2str(5+t*5)   '.mat'],'net');
    fig_num=fig_num+1;
    print(1,'-dtiff',[saveDir '/' 'confusion_maxtrix'  '_'  num2str(5+t*5) '.tif']);
    savefig(1,[saveDir '/' 'confusion_maxtrix'  '_'  num2str(5+t*5) '.fig']);
    close all;
    %clear('net');
end

