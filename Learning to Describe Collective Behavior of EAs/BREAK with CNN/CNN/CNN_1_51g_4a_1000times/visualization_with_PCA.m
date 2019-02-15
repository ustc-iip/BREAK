% analysize_outputFeature_of_different_layer
clear
close all;
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
Landscapes_2={'','Sphere_5_50_3_32','Sphere_6_25_5_16_3_16','Sphere_new','Sphere_5_25','Sphere_5_50'};

for L=[1:10,14]
    fprintf('Loding xTest_cnn...\n ');
    load([rootDir Landscapes{L} '/' 'xTest_cnn.mat']);
    load([rootDir Landscapes{L} '/' 'yTest_cnn.mat']);
    label=int8(yTest_cnn);
    % saveDir='Feature_pca_V_D/';
    %for L2=1
    fprintf('Loding network...\n ');
    %file=ls([Landscapes_2{L2} '/'  'net/*.mat']);       % obtain full directory of the file
    file=ls(['all_net/*.mat']);       % obtain full directory of the file
    if  length(file)>50
        Tmp=split(file,' ');
        load(char(Tmp(1)));
    else
        load(file(1:end-1));
    end
    for iter=1
        %load([Landscapes_2{L2} '/' 'net/'  file(iter,:)]);
        
        [~,~,~,num]=size(xTest_cnn);
        len_layers=length(net.Layers);
        %index=randperm(num);
        % traversal feature layer 7 to10
        for i=[len_layers-4,len_layers-3,len_layers-2]
            outputFeatures = activations(net,xTest_cnn,i);     % extract output of the specify layer
            V=[];
            D=[];
            [Feature_PCA,V,D]=mypca(outputFeatures,4);
            % [COEFF, SCORE] = pca(outputFeatures,'NumComponents',4) ;
            index1=find(label==1);
            index2=find(label==2);
            index3=find(label==3);
            index4=find(label==4);
%             index5=find(label==5);
%             index6=find(label==6);
%             index7=find(label==7);
            %         index8=find(label==8);
            %         index9=find(label==9);
            figure(i)
            plot(Feature_PCA(index1,1),Feature_PCA(index1,2),'*');
            hold on
            plot(Feature_PCA(index2,1),Feature_PCA(index2,2),'+');
            plot(Feature_PCA(index3,1),Feature_PCA(index3,2),'o');
            plot(Feature_PCA(index4,1),Feature_PCA(index4,2),'.');
%             plot(Feature_PCA(index5,1),Feature_PCA(index5,2),'.');
%             plot(Feature_PCA(index6,1),Feature_PCA(index6,2),'.');
%             plot(Feature_PCA(index7,1),Feature_PCA(index7,2),'.');
            %         plot(Feature_PCA(index8,1),Feature_PCA(index8,2),'.');
            %         plot(Feature_PCA(index9,1),Feature_PCA(index9,2),'.');
            %         scatter3(DE(index2,1),DE(index2,2),DE(index2,3),'*g');
            legend1=legend('CEP','DE','ES','GA','Location','northeast');
            set(legend1);           % ,'FontSize',24
            title(Landscapes{L},'Fontsize',28);
            xlabel('feature1','Fontsize',20);
            ylabel('feature2','Fontsize',20);
            %zlabel('feature3','Fontsize',20);
            %saveDir=[Landscapes_2{L2} '/' 'visualization_result_2D/'];
            saveDir=[Landscapes{L} '/' 'visualization_result_2D/'];
            if ~exist(saveDir)
                mkdir(saveDir);
            end
            
            print(i,'-dtiff',[saveDir 'cluster'   num2str(i) '_iter_' num2str(iter*10) '.tif']);
            savefig(i,[saveDir 'cluster'   num2str(i) '_iter_' num2str(iter*10) '.fig']);
            hold off
        end
    end
    
    
end
