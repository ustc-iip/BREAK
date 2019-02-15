% generate trainning data Xtrain and test data xTest
% get 500 times run and 100 generation
clear
clc

xTrain=[];
yTrain=[];
xTest=[];
yTest=[];
%Algrithms={'CEP','CMA','ES','GA','DE','GARAU','PSO'};
Algrithms={'CEP','DE','ES','GA'}  %'GARAU','GARBG','GATBG','GAUSU','ABC','EDA','CMA','PSO'};
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
inputRootDir='result/som_rawdata100/';
saveRoot='BehaviorData_for_analysis/';
%saveDir='CNN_DNN_1_11_9_25/';
length_generation=100;
length_alg=4;
runs=1000;
saveDir=[saveRoot 'CNN_1_'  num2str(length_generation+1) 'g_' num2str(length_alg) 'a_' num2str(runs)   'times'  '_withoutdiff'];
if ~exist(saveDir)
    mkdir(saveDir);
end
%saveDir='CNN_GAm_100/';
tic
for i= [1,2,3,6,8,9]      %control  Landscapes
    yTrain=[];
    yTest=[];
    xTrain=[];
    xTest=[];
    count=1;
    %length(Algrithms);
    for j=[1:length_alg]              %1:length_alg  %control Algrithms
        parfor k=1:700
            somMaps=load([ inputRootDir Landscapes{i}  '/' Algrithms{j} '/' 'run_' num2str(k) '/' 'diff_hits.mat']);
            %selMapsTrain1=somMaps.hits(:,1:length_generation);
            %selMapsTrain2=somMaps.hits(:,2:length_generation+1);
            %selMapsTrain=int8(selMapsTrain2-selMapsTrain1);
            selMapsTrain=somMaps.diff_hits(:,1:length_generation);
            xTrain=[xTrain,selMapsTrain];
        end
        parfor k=701:1000
            somMaps=load([inputRootDir Landscapes{i}  '/' Algrithms{j} '/' 'run_' num2str(k) '/' 'diff_hits.mat']);
            %             selMapsTest1=somMaps.hits(:,1:length_generation);
            %             selMapsTest2=somMaps.hits(:,2:length_generation+1);
            %             selMapsTest=int8(selMapsTest2-selMapsTest1);
            selMapsTest=somMaps.diff_hits(:,1:length_generation);
            xTest=[xTest,selMapsTest];
        end
        
        y=zeros(length_alg,1);
        y(count)=1;
        count=count+1;
        
        yMartix=repmat(y,1,7000*length_generation);
        yTrain=[yTrain yMartix];
        yMartixTest=repmat(y,1,3000*length_generation);
        yTest=[yTest,yMartixTest];
    end
    %     if ~exist([saveRoot Landscapes{i} '/' saveDir] )
    %         mkdir([saveRoot Landscapes{i} '/' saveDir] );
    %     end
    %     save([ inputRootDir Landscapes{i} '/' saveDir  'xTrain'],'xTrain','-v7.3');
    %     save([inputRootDir Landscapes{i} '/' saveDir 'xTest'],'xTest','-v7.3');
    %     save([inputRootDir Landscapes{i} '/' saveDir  'yTrain'],'yTrain','-v7.3');
    %     save([inputRootDir Landscapes{i}  '/' saveDir   'yTest'],'yTest','-v7.3');
    
    % calculate CNN trainning data
    %yTrain=categorical();
    %yTest=categorical();
    [xTrain_rows,xTrain_cols]=size(xTrain);
    [xTest_rows,xTest_cols]=size(xTest);
    
    xTrain_cnn=reshape(xTrain,100,100,1,xTrain_cols);
    xTest_cnn=reshape(xTest,100,100,1,xTest_cols);
    ytrain_num=xTrain_cols/length_alg;
    yTest_num=xTest_cols/length_alg;
    %     yTrain=[ones(ytrain_num,1);2*ones(ytrain_num,1);3*ones(ytrain_num,1);4*ones(ytrain_num,1);5*ones(ytrain_num,1);6*ones(ytrain_num,1)];
    %     yTest=[ones(yTest_num,1);2*ones(yTest_num,1);3*ones(yTest_num,1);4*ones(yTest_num,1);5*ones(yTest_num,1);6*ones(yTest_num,1)];
    yTrain=[];
    yTest=[];
    for m=1:length_alg
        yTrain=[yTrain;m*ones(ytrain_num,1)];
        yTest=[yTest;m*ones(yTest_num,1)];
    end
    yTrain_cnn=categorical(yTrain);
    yTest_cnn=categorical(yTest);
    xTrain_cnn=int8(xTrain_cnn);                                         % convert double to int8
    xTest_cnn=int8(xTest_cnn);
    if ~exist([saveDir '/' Landscapes{i} '/'])
        mkdir([saveDir '/' Landscapes{i} '/']);
    end
    save([saveDir '/' Landscapes{i} '/' 'xTrain_cnn'],'xTrain_cnn','-v7.3');
    save([ saveDir '/' Landscapes{i} '/'  'xTest_cnn'],'xTest_cnn','-v7.3');
    save([ saveDir '/' Landscapes{i} '/' 'yTrain_cnn'],'yTrain_cnn','-v7.3');
    save([ saveDir '/' Landscapes{i} '/'  'yTest_cnn'],'yTest_cnn','-v7.3');
end
toc






