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
    xTest=[];
    yTest=[];
    for L=[1,2,3,6,8,9]        % control Landscapes
        src_xTrian=[rootDir srcDirs{i} Landscapes{L} '/'   'xTest_cnn.mat'];
        xTest_tmp=load(src_xTrian);
        xTest_tmp.xTest_cnn=int8(xTest_tmp.xTest_cnn);         %convert double to int8
        %index=find(sum(sum(abs(xTest_tmp.xTest_cnn)))==0);
        %xTest_tmp.xTest_cnn(:,:,:,index)=[];
        xTest=cat(4,xTest,xTest_tmp.xTest_cnn);
        clear('xTest_tmp.xTest_cnn');
        
        src_yTrian=[rootDir srcDirs{i} Landscapes{L} '/'   'yTest_cnn.mat'];
        yTest_tmp=load(src_yTrian);
        %yTest_tmp. yTest_cnn(index)=[];
        yTest=[yTest;yTest_tmp.yTest_cnn];
        clear('yTest_tmp.yTest_cnn');
        [d1,d2,d3,d4]=size(xTest)
    end
    if ~exist([rootDir srcDirs{i} '/' saveDir ])
        mkdir([rootDir srcDirs{i} '/' saveDir]);
    end
    save([rootDir srcDirs{i}  '/' saveDir '/' 'xTest.mat'],'xTest','-v7.3');
    save([rootDir srcDirs{i}  '/' saveDir '/' 'yTest.mat'],'yTest','-v7.3');
end