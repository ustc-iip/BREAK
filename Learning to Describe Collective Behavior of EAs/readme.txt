ע�⣺��ִ�����г���ʱӦ����ע�������������ݵ�·��

********************************************************************************************************************************
�ļ��У�BehaviorDataCollection�����������ݻ������һ����Ⱥ������ʱ��Ҫ��Ϊ������
step1: ����get_initial_pop.m ��ȡ��ʼ��Ⱥ���������ó�ʼ��Ⱥ�Ĵ�СNP��ά��D�ͳ�ʼ����[lb, ub]
step2: ����BehaviorDataCollection.m ����һ�ε��������Ⱥ����

********************************************************************************************************************************
�ļ��У�som������ѵ��SOM����ʹ��ѵ���õ�SOM������ݻ�������Ⱥ��������һ����ʾ
step1: SOMѵ��������SOM.m������SOMѵ��ʱ��ϳ������ļ������Ѿ�ѵ���������ֹ�ģ��SOM���磬����ֱ��ʹ�ã�����ʹ��100*100��С��SOM��
step2: SOMӳ�䣬����data_output_som_parfor.m

********************************************************************************************************************************
�ļ��У�SFA_for_EA��ͨ��SFA���ݻ�������Ϊ���ݽ�����������ȡ��ִ�в������£�
step1: ���ļ���sfa_tk�������ļ�����ӵ�����·����
step2: ����mainSFA.m��ȡ�õ�ѵ�����ݺͲ������ݵ�������������
step3: ����FeatureImageDrawing_train.m����ѵ�����ݵ��������ֲ�ɢ��ͼ
step4: ����FeatureImageDrawing_test.m�����������ݵ��������ֲ�ɢ��ͼ

********************************************************************************************************************************
�ļ��У�DBN_for_EA��ͨ���������������ݻ�������Ϊ���ݽ�����������ȡ��ִ�в������£�
step1: ���ݻ�������Ϊ���ݰ����ļ���'\+EAdata\SFAData20170309_DBN'�и�ʽ������֯
step2: ѡ��benchmark function����'\+EAdata\prepareEAdata_som_20170309.m'���޸���Ϊ���ݶ�ȡ·��
step3: ִ��getFeatureEAdata.m��ȡ���������������ֲ�ɢ��ͼ����getFeatureEAdata.m�п���ֱ���޸�DBN�����������ÿһ�����Ԫ�ڵ����ȣ�

����ʹ�õ�DBN���������׽�������վ��ҳ����ͨ����ҳ��ע�ù�����ĸ��£������������˽�ù������ʹ�ã������ṩ�����MNIST�����ݼ��ĳ������ѧϰ�ù������ʹ�ã�������ҳ������ѧϰ��
��ҳ��http://ceit.aut.ac.ir/~keyvanrad/DeeBNet%20Toolbox.html
���ģ�A brief survey on deep belief networks and introducing a new object oriented toolbox (DeeBNet)

Where:
DeepLearnToolboxGPU Toolbox is based on the DeepLearnToolbox by Rasmus Berg Palm (https://github.com/rasmusbergpalm/DeepLearnToolbox)
sfa-tk 1.0.1 is a Matlab implementation of the slow feature analysis algorithm (SFA). sfa-tk can be found at  http://itb.biologie.hu-berlin.de/~berkes/software/sfa-tk/sfa-tk.shtml
DeeBNet is modified version of deep belief networks toolbox from http://ceit.aut.ac.ir/~keyvanrad/DeeBNet%20Toolbox.html