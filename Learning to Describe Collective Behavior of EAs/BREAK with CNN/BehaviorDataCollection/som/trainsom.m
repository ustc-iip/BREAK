function Map = trainsom(Map, traindata, train_epochs, varargin)
%TRAINSOM  train the Self-Organizing Map by using batch algorithm.

% Input and output arguments ([]'s are optional):
%   Map             : (struct) input the map needed to be trained and return the updated map
%   traindata       : (matrix) train data, length*dim
%   train_epochs    : (scalar) the length(epochs) of the train process
%   [radius]        : (vector) length=2. radius(1) is the original radius.
%                           radius(2) is the final.Default is [1 1/10]*max(Map.map_size)
%                           if the argument 'how2train' is 'rough';
%                           [1/10*max(Map.map_size)  0.01], if 'how2train is 'finetune'. 
%                           [max(Map.map_size) 0.01]if is 'total'.
%   [batch_size]    : (scalar) Default is size(traindata,1). If batch_size is specified, the 
%                           traindata will be divided into several parts. length of each parts 
%                           is batch_size. This argument is specified is the  memory of your 
%                           computer is not enough.
%   [how2train]     : (string) 'rough', 'finetune' or 'total'. Default is 'total'.

% 
%   Detailed explanation goes here
%





narginchk(3, 6);  % check input argumentsã€?if less than 2 or more than 5, error.

validdata = sum(isnan(traindata), 2) == 0;
traindata = traindata(validdata, :);                    % remove bad  data from the traindata
[datalen, datadim] = size(traindata);                      % check data dimension with map
if Map.dim ~= datadim, 
  error('check data dimension with Maps dimension, they should be the same'); 
end

%here are some default set.
radius = [];
batch_size = size(traindata, 1);
how2train = 'total';

i=1; 
while i<=length(varargin), 
    switch varargin{i},
		case 'radius', 
			i=i+1;
			radius = varargin{i};
     	case 'batch_size', 
     		i=i+1;   
     		batch_size = varargin{i};
     	case 'how2train', 
     		i=i+1; 
     		how2train = varargin{i}; 

         otherwise
             error(' wrong input argument');
     end
     i=i+1;
end

if isempty(radius),
 	if strcmp(how2train, 'rough'),
 		radius = [1 1/10]*max(Map.map_size);
 	elseif strcmp(how2train, 'finetune'),
 		radius = [1/10*max(Map.map_size) 0.01];
 	else
 		radius = [max(Map.map_size) 0.01];
 		
 	end;
end;

detail_radius = radius(2)+((train_epochs-1):-1:0)/(train_epochs-1)*(radius(1)-radius(2));

dis_units = cal_unit_distance(Map.map_size, Map.shape);
dis_units = dis_units.^2;
detail_radius = 2*(detail_radius.^2);
detail_radius(detail_radius==0) = eps; 




Vecs = Map.ref_vects;
Data = 2*traindata';

best_units = zeros(1, datalen); 

for t = 1:train_epochs,  
	Vecs2 = sum(Vecs.^2, 2);
	i0 = 0;     
    while i0+1<=datalen,
    	index = [(i0+1):min(datalen, i0+batch_size)]; 
    	i0 = i0+batch_size;      
    	Dist = bsxfun(@minus, Vecs2, Vecs*Data(:, index));
    	[ ~, best_units(index)] = min(Dist);
  	end  
  
	H = exp(-dis_units/detail_radius(t)); 
	Hitmartix = sparse(best_units, 1:datalen, 1, prod(Map.map_size), datalen);

 	All = H*(Hitmartix*traindata); 
	divisor= H*sum(Hitmartix,2);
  

  	notzero = find(divisor > 0); 
  	Vecs(notzero, :) = bsxfun(@rdivide, All(notzero, :), divisor(notzero)); 

end; 

Map.ref_vects = Vecs;
Map.how2train = how2train;
Map.radius = radius;

end


