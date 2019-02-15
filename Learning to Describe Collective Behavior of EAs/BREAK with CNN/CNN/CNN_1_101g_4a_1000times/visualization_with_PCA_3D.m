% analysize_outputFeature_of_different_layer
clear
close all;
rootDir='../../BehaviorDataCollection/BehaviorData_for_analysis/CNN_1_51g_4a_1000times_withoutdiff/';
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
load('all_net/net_99.6348_25.mat');

for L=[1,2,3,6,8,9]  
    fprintf('Loding xTest_cnn...\n ');
    load([rootDir Landscapes{L} '/' 'xTest_cnn.mat']);
    load([rootDir Landscapes{L} '/' 'yTest_cnn.mat']);
    label=int8(yTest_cnn);
    saveDir=['result_CNN_visual' '/' 'visualization_result_3D/'];
    if ~exist(saveDir)
        mkdir(saveDir);
    end
    %% get network
    %     file=ls(['all_net/*.mat']);       % obtain full directory of the file
    %     if  length(file)>50
    %         Tmp=split(file,' ');
    %         load(char(Tmp(1)));
    %     else
    %         load(file(1:end-1));
    %     end
    %index=randperm(num);
    %% traversal feature layer 7 to10
    length_layers=length(net.Layers);
    for i=[length_layers-4,length_layers-3]
        outputFeatures = activations(net,xTest_cnn,i);     % extract output of the specify layer
        V=[];
        D=[];
        [Feature_PCA,V,D]=mypca_2(outputFeatures,3);
        % [COEFF, SCORE] = pca(outputFeatures,'NumComponents',4) ;
        index1=find(label==1);
        index2=find(label==2);
        index3=find(label==3);
        index4=find(label==4);
        %         index5=find(label==5);
        %         index6=find(label==6);
        %         index7=find(label==7);
        %         index8=find(label==8);
        %         index9=find(label==9);
        figure(i)
        scatter3(Feature_PCA(index1,1),Feature_PCA(index1,2),Feature_PCA(index1,3),'sk');
        hold on
        scatter3(Feature_PCA(index2,1),Feature_PCA(index2,2),Feature_PCA(index2,3),'ob');
        scatter3(Feature_PCA(index3,1),Feature_PCA(index3,2),Feature_PCA(index3,3),'*g');
        scatter3(Feature_PCA(index4,1),Feature_PCA(index4,2),Feature_PCA(index4,3),'+r');
%         scatter3(Feature_PCA(index5,1),Feature_PCA(index5,2),Feature_PCA(index5,3),'.y');
        %         scatter3(Feature_PCA(index5,1),Feature_PCA(index5,2),Feature_PCA(index5,3),'.');
        %         scatter3(Feature_PCA(index6,1),Feature_PCA(index6,2),Feature_PCA(index6,3),'.');
        %         scatter3(Feature_PCA(index7,1),Feature_PCA(index7,2),Feature_PCA(index7,3),'.');
        %         plot(Feature_PCA(index8,1),Feature_PCA(index8,2),'.');
        %         plot(Feature_PCA(index9,1),Feature_PCA(index9,2),'.');
        %   scatter3(DE(index2,1),DE(index2,2),DE(index2,3),'*g');
        legend1=legend('CEP','DE','ES','GA','Location','bestoutside');  %,'Location','northeast'
        set(legend1 ,'FontSize',24);           % ,'FontSize',24
        title(Landscapes{L},'Fontsize',32,'Interpreter','latex');
        xlabel('feature1','Fontsize',20,'Interpreter','latex');
        ylabel('feature2','Fontsize',20,'Interpreter','latex');
        zlabel('feature3','Fontsize',20,'Interpreter','latex');
        %zlabel('feature3','Fontsize',20);
        if ~exist(saveDir)
            mkdir(saveDir);
        end
        set(gcf,'position',[0,0,1000,680]);
        print(i,'-dtiff',[saveDir '/' Landscapes{L} '_' num2str(i) '_3D.tif']);
        print('-painters','-depsc',[saveDir '/' Landscapes{L} '_' num2str(i) '_3D.eps']);
        savefig(i,[saveDir '/' Landscapes{L} '_' num2str(i) '_3D.fig']);
        hold off
    end
end