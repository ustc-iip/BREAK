% train a CNN
% 'CEP','ES','DE','GAc5'
clear
clc
rootDir='../../BehaviorDataCollection/BehaviorData_for_analysis/CNN_1_2g_4a_10000times_withoutdiff/';
Algrithms={'CEP','ES','DE','GARAU','GARBG','GATBG','GAUSU','ABC','EDA','CMA','PSO'};
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
length_algs=7;
for L=[1:10,14]
    load([rootDir Landscapes{L} '/' 'xTrain_cnn.mat']);
    load([rootDir Landscapes{L} '/'  'yTrain_cnn.mat']);
    load([rootDir Landscapes{L} '/' 'xTest_cnn.mat']);
    load([rootDir Landscapes{L} '/'  'yTest_cnn.mat']);
    % index=find(sum(sum(abs(xTrain)))==0|sum(sum(abs(xTrain)))==2);
    % xTrain(:,:,:,index)=[];
    % [d1,d2,d3,d4]=size(xTrain);
    % yTrain(index)=[];
    %% Construct the convolutional neural network architecture.
    
    layers = [imageInputLayer([100 100 1],'Normalization','none');
        convolution2dLayer(5,25);
        reluLayer();
        maxPooling2dLayer(4,'Stride',4);
        convolution2dLayer(3,16);
        reluLayer();
        maxPooling2dLayer(2,'Stride',2);
        %         convolution2dLayer(3,32);
        %         reluLayer();
        %         maxPooling2dLayer(2,'Stride',2);
        %fullyConnectedLayer(1024);
        fullyConnectedLayer(256);
        reluLayer();
        fullyConnectedLayer(7);
        softmaxLayer();
        classificationLayer()];
    %Set the options to default settings for the stochastic gradient descent with momentum.
    
    opts = trainingOptions('sgdm','MaxEpochs', 1);
    %Pretrain the network.
    net = trainNetwork(xTrain_cnn,yTrain_cnn,layers,opts);
    %% train the network.
    for it=30
        opts = trainingOptions('sgdm','MaxEpochs', it);
        %Train the network.
        tic
        net = trainNetwork(xTrain_cnn,yTrain_cnn,net.Layers,opts);
        toc
        % Manually compute the train overall accuracy.
        it
        trainPredictions_cnn = classify(net,xTest_cnn);
        accuracy_Train = sum(yTest_cnn == trainPredictions_cnn)/numel(yTest_cnn)
        ytest= dummyvar(double(yTest_cnn))'; % dummyvar requires Statistics and Machine Learning Toolbox
        ypredictions = dummyvar(double(trainPredictions_cnn))';
        figure()
        plotconfusion(ytest,ypredictions);
        saveDir=[Landscapes{L}  '/' 'net/'];
        if ~exist(saveDir)
            mkdir(saveDir)
        end
        save([saveDir 'net_' 'inter_' num2str(it)  '_'  num2str(accuracy_Train*100) '.mat'],'net');
        print(1,'-dtiff',[saveDir '/' 'confusion_maxtrix'  '_'   num2str(it) '.tif']);
        savefig(1,[saveDir '/' 'confusion_maxtrix'  '_'   num2str(it) '.fig']);
        %         save([saveDir 'net_' 'inter_' num2str(it*10)  '_'  num2str(accuracy_Train*100) '.mat'],'net');
        %         print(1,'-dtiff',[saveDir '/' 'confusion_maxtrix'  '_'  num2str(it*10) '.tif']);
        %         savefig(1,[saveDir '/' 'confusion_maxtrix'  '_'   num2str(it*10) '.fig']);
        close all;
        %clear('net');
    end
end
