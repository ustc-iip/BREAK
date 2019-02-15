load train_data.mat
load 'map/Map100_rough.mat'
finetune_epoch = 80000;
Map = trainsom(Map, train_data, finetune_epoch, 'how2train', 'finetune');
save(['map/Map'  int2str(row_units)  '_finetune.mat'], 'Map');