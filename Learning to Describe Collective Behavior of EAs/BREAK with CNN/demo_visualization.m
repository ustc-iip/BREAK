% analysize_outputFeature_of_different_layer
%clear
close all;
rootDir='data_for_demo/CNN_1_2g_4a_10000times/';
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
Landscapes2={  'Sphere', 'Schwefel','Elliptic','','','Rosenbrock','','Ackley','Rastrigin'};
% load Trained CNN Model
fprintf('Loding network...\n ');
load('CNN_model/net_99.7306_25.mat');

% load mapping vector
load('V.mat');
%load('PCA_V_1_101/V_10.mat');
saveDir=['result_CNN_visual_PCA_V_1_101_net_data10' '/' 'visualization_result_2D/'];
for L=[1,2,3,6,8,9]
    fprintf('Loding xTest_cnn...\n ');
    load([rootDir Landscapes{L} '/' 'xTest_cnn.mat']);
    load([rootDir Landscapes{L} '/'  'yTest_cnn.mat']);
    label=int8(yTest_cnn);
    
    if ~exist(saveDir)
        mkdir(saveDir);
    end
    
    %file=ls(['net/*.mat']);       % obtain full directory of the file
    %load(['net/'  file(1:end)]);
    %load(file);
    %load('net/net_97.7917_30.mat');
    [~,~,~,num]=size(xTest_cnn);
    %index=randperm(num);
    % traversal feature layer 7 to10
    length_layers=length(net.Layers);
    for i=[length_layers-3]   %length_layers-4,
        outputFeatures = activations(net,xTest_cnn,i);     % extract output of the specify layer
        %[Feature_PCA,V,D]=mypca(outputFeatures,2);
        %[Feature_PCA,V,D]=mypca_2(outputFeatures,2);
        Feature_PCA=outputFeatures*V;
        % [COEFF, SCORE] = pca(outputFeatures,'NumComponents',4) ;
        index1=find(label==1);
        index2=find(label==2);
        index3=find(label==3);
        index4=find(label==4);
        %         index5=find(label==5);
        figure(i)
        plot(Feature_PCA(index1,1),Feature_PCA(index1,2),'sk');
        hold on
        plot(Feature_PCA(index2,1),Feature_PCA(index2,2),'ob');
        plot(Feature_PCA(index3,1),Feature_PCA(index3,2),'*g');
        plot(Feature_PCA(index4,1),Feature_PCA(index4,2),'+r');
        %   plot(Feature_PCA(index5,1),Feature_PCA(index5,2),'.y');
        %   scatter3(DE(index2,1),DE(index2,2),DE(index2,3),'*g');
        legend1=legend('CEP','DE','ES','GA','Location','best');  %,'Location','northeast'
        
        set(legend1 ,'FontSize',28,'Interpreter','latex');           % ,'FontSize',24
        title(Landscapes2{L},'Fontsize',36,'Interpreter','latex');
        xlabel('feature1','Fontsize',32,'Interpreter','latex');
        ylabel('feature2','Fontsize',32,'Interpreter','latex');
        %zlabel('feature3','Fontsize',20);
        if ~exist(saveDir)
            mkdir(saveDir);
        end
        set(gcf,'position',[0,0,1000,680]);
        print(i,'-dtiff',[saveDir '/' Landscapes2{L} '_' num2str(i) '_2D.tif']);
        print('-painters','-depsc',[saveDir '/' Landscapes2{L} '_' num2str(i) '_2D.eps'])
        savefig(i,[saveDir '/' Landscapes2{L} '_' num2str(i) '_2D.fig']);
        
        hold off
    end
end