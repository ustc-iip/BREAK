% merge 6-landscape
clear
clc
% set directory
rootDir='BehaviorData_for_analysis/';
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
 srcDirs={'CNN_1_2g_4a_1000times_withoutdiff/','CNN_1_6g_4a_1000times_withoutdiff/','CNN_1_11g_4a_1000times_withoutdiff/','CNN_1_101g_4a_1000times_withoutdiff/','CNN_1_51g_4a_1000times_withoutdiff/','CNN_1_11g_4a_1000times_withoutdiff/','CNN_1_2g_5a_10000timesABC_CMA_CoDE_SPSO2011_SaDE_diff/','CNN_1_2g_14a_10000times_diff/','CNN_1_2g_14a_10000times_withoutdiff/','CNN_1_2g_5a_10000timesABC_CMA_CoDE_SaDE_SPSO2011withoutdiff/','CNN_1_2g_4a_10000times_withoutdiff/','CNN_DNN_1_11_9_25/', 'CNN_DNN_1_101_9_25/','CNN_DNN_1_11_7_25/'};
saveDir='all_testFunction/';
%destDir='CNN_DNN_1_100_4_9/';
for i=1
    xTrain=[];
    yTrain=[];
    for L= [1,2,3,6,8,9]    %[1:10,14]        % control Landscapes
        src_xTrian=[rootDir srcDirs{i} Landscapes{L} '/'   'xTrain_cnn.mat'];
        xTrain_tmp=load(src_xTrian);
        xTrain_tmp.xTrain_cnn=int8(xTrain_tmp.xTrain_cnn);         %convert double to int8
        %index=find(sum(sum(abs(xTrain_tmp.xTrain_cnn)))==0);
        %xTrain_tmp.xTrain_cnn(:,:,:,index)=[];
        xTrain=cat(4,xTrain,xTrain_tmp.xTrain_cnn);
        clear('xTrain_tmp.xTrain_cnn');
        
        src_yTrian=[rootDir srcDirs{i} Landscapes{L} '/'   'yTrain_cnn.mat'];
        yTrain_tmp=load(src_yTrian);
        %yTrain_tmp. yTrain_cnn(index)=[];
        yTrain=[yTrain;yTrain_tmp.yTrain_cnn];
        clear('yTrain_tmp.yTrain_cnn');
        [d1,d2,d3,d4]=size(xTrain)
    end
    if ~exist([rootDir srcDirs{i} '/' saveDir ])
        mkdir([rootDir srcDirs{i} '/' saveDir]);
    end
    save([rootDir srcDirs{i}  '/' saveDir '/' 'xTrain.mat'],'xTrain','-v7.3');
    save([rootDir srcDirs{i}  '/' saveDir '/' 'yTrain.mat'],'yTrain','-v7.3');
end