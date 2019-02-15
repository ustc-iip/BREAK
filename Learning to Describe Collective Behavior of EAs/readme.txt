注意：在执行下列程序时应首先注意输入和输出数据的路径

********************************************************************************************************************************
文件夹：BehaviorDataCollection，用于生成演化计算的一代种群，运行时主要分为两步：
step1: 运行get_initial_pop.m 获取初始种群，可以设置初始种群的大小NP，维数D和初始区间[lb, ub]
step2: 运行BehaviorDataCollection.m 生成一次迭代后的种群数据

********************************************************************************************************************************
文件夹：som，用于训练SOM，并使用训练好的SOM网络对演化计算种群数据做归一化表示
step1: SOM训练，运行SOM.m（由于SOM训练时间较长，在文件夹中已经训练好了三种规模的SOM网络，可以直接使用，建议使用100*100大小的SOM）
step2: SOM映射，运行data_output_som_parfor.m

********************************************************************************************************************************
文件夹：SFA_for_EA，通过SFA对演化计算行为数据进行慢特征提取，执行步骤如下：
step1: 将文件夹sfa_tk及其子文件夹添加到工作路径中
step2: 运行mainSFA.m提取得到训练数据和测试数据的慢特征并保存
step3: 运行FeatureImageDrawing_train.m画出训练数据的慢特征分布散点图
step4: 运行FeatureImageDrawing_test.m画出测试数据的慢特征分布散点图

********************************************************************************************************************************
文件夹：DBN_for_EA，通过深度信念网络对演化计算行为数据进行慢特征提取，执行步骤如下：
step1: 将演化计算行为数据按照文件夹'\+EAdata\SFAData20170309_DBN'中格式进行组织
step2: 选定benchmark function后，在'\+EAdata\prepareEAdata_som_20170309.m'中修改行为数据读取路径
step3: 执行getFeatureEAdata.m提取特征并画出特征分布散点图（在getFeatureEAdata.m中可以直接修改DBN的网络层数、每一层的神经元节点数等）

附：使用的DBN工具箱文献介绍与网站主页，可通过主页关注该工具箱的更新，并根据论文了解该工具箱的使用，作者提供了针对MNIST等数据集的程序帮助学习该工具箱的使用，可在主页中下载学习。
主页：http://ceit.aut.ac.ir/~keyvanrad/DeeBNet%20Toolbox.html
论文：A brief survey on deep belief networks and introducing a new object oriented toolbox (DeeBNet)

Where:
DeepLearnToolboxGPU Toolbox is based on the DeepLearnToolbox by Rasmus Berg Palm (https://github.com/rasmusbergpalm/DeepLearnToolbox)
sfa-tk 1.0.1 is a Matlab implementation of the slow feature analysis algorithm (SFA). sfa-tk can be found at  http://itb.biologie.hu-berlin.de/~berkes/software/sfa-tk/sfa-tk.shtml
DeeBNet is modified version of deep belief networks toolbox from http://ceit.aut.ac.ir/~keyvanrad/DeeBNet%20Toolbox.html