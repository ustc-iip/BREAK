for t=1:5
    opts = trainingOptions('sgdm','MaxEpochs', 2,'MiniBatchSize',1024);
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
    saveDir=['net_fine_tune/'];
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    save([ saveDir '/' 'net_' num2str(accuracy_Train*100) '_'  num2str(t*5)   '.mat'],'net');
    fig_num=fig_num+1;
    print(1,'-dtiff',[saveDir '/' 'confusion_maxtrix'  '_'  num2str(t*2) '.tif']);
    savefig(1,[saveDir '/' 'confusion_maxtrix'  '_'  num2str(t*2) '.fig']);
    close all;
    %clear('net');
end