function SOM
row_units = 100;  		%row_units is the size of the square SOM grid.
num_units = row_units*row_units;
data_dim = 2;			% data_dim is the dimension of Map's ref_vects.
num_traindata = 100000;
%num_traindata is the num of train_data, please note the num of SOM's units
%then set  a appropriate value.
rough_epoch = 20000;
finetune_epoch = 80000;
%The train_epochs should be set appropriately.

lb = -32;
ub = 32;

train_data=unifrnd(lb, ub, num_traindata, data_dim);
save('train_data.mat', 'train_data');

tsne_data=unifrnd(lb, ub, num_units, data_dim);
mkdir('pretrain/image');
save('pretrain/tsne_data.mat','tsne_data');

no_dims = 2;
init_dims = data_dim;
perplexity = 30;
%Run t-SNE, remember clear the PCA part in the toolbox
mappedX = tsne ( tsne_data,[], no_dims , init_dims , perplexity );
% Plot results
save('pretrain/mappedX.mat','mappedX');

gscatter ( mappedX(:,1), mappedX(:,2) );
saveas(gcf,sprintf('pretrain/image/prehitmap.jpg'));
close all;


[THETA,RHO] = cart2pol(mappedX(:,1),mappedX(:,2));
transform=zeros(num_units,2);
temp_ind=find(((-pi/4)<=THETA&THETA<=(pi/4)));
transform(temp_ind,1)= RHO(temp_ind);
transform(temp_ind,2)= transform(temp_ind,1).*tan(THETA(temp_ind));

temp_ind=find(((3*pi/4)<=THETA&THETA<=(pi))|((-pi)<=THETA&THETA<=(-3*pi/4)));
transform(temp_ind,1)= -RHO(temp_ind);
transform(temp_ind,2)= transform(temp_ind,1).*tan(THETA(temp_ind));

temp_ind=find(((-3*pi/4)<THETA&THETA<(-pi/4)));
transform(temp_ind,2)= -RHO(temp_ind);
transform(temp_ind,1)= -transform(temp_ind,2).*tan(pi/2+THETA(temp_ind));

temp_ind=find(((pi/4)<THETA&THETA<(3*pi/4)));
transform(temp_ind,2)= RHO(temp_ind);
transform(temp_ind,1)= transform(temp_ind,2).*tan(pi/2-THETA(temp_ind));

save('pretrain/transform.mat','transform');
gscatter ( transform(:,1), transform(:,2) );
saveas(gcf,sprintf('pretrain/image/transform.jpg'));
close all;

final_all=zeros(num_units,2);
final_hit=zeros(num_units,1);
[sheng,pos] = sortrows(transform,1);
for i=row_units:row_units:num_units
    tempcol=sheng(i-(row_units-1):i,:);
    [final_all(i-(row_units-1):i,:),later]=sortrows(tempcol,-2);
    aaa=pos(i-(row_units-1):i);
    final_hit(i-(row_units-1):i,:)= aaa(later);
end

save('pretrain/final.mat','final_all','final_hit');

fprintf('start initializing SOM...\n\n');
mkdir('map');
Map = creatsom([row_units row_units], data_dim, 'hexa', [lb, ub]);
fprintf('caculating codebook...\n\n');
Map.ref_vects = tsne_data(final_hit,:);
save(['map/Map'  int2str(row_units)  '_pre.mat'], 'Map');

fprintf('rough training...\n\n');
%The train_epochs should be set appropriately.
%Because the train process may last several days, if the train process interrupt
%unexpectedly and you want to continue, you can load the data saved by trainsom.m
%then start again. However you should comment most part of the above code or write
%a new one.
Map = trainsom(Map, train_data, rough_epoch, 'how2train', 'rough');
save(['map/Map'  int2str(row_units)  '_rough.mat'], 'Map');


fprintf('finetune training...\n\n');
Map = trainsom(Map, train_data, finetune_epoch, 'how2train', 'finetune');
save(['map/Map'  int2str(row_units)  '_finetune.mat'], 'Map');
