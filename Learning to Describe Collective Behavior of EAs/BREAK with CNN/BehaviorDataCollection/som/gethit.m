function [hits, best_index] = gethit(Map, Origindata)
%GETHIT  get the hit vector indicate the frequency of hit to each map unit.
%

% Input and output arguments ([]'s are optional):
%	Map  		 	: (struct) input a som map struct
%	Origindata		: (matrix) original data, length*dim
%	hits			: (vector) length*1, length = the number of units in the map
% 
%   Detailed explanation goes here
%
[datalen, datadim] = size(Origindata);
if Map.dim ~= datadim, 
  error('check data dimension with Maps dimension, they should be the same'); 
end

batch_size = datalen;	% if there are too many data, you can set it smaller. 
						% default is all data. 


Vecs = Map.ref_vects;
Origindata = 2*Origindata';
best_units = zeros(1, datalen); 

Vecs2 = sum(Vecs.^2, 2);
i0 = 0;     
while i0+1<=datalen,
    index = [(i0+1):min(datalen, i0+batch_size)]; 
    i0 = i0+batch_size;      
    Dist = bsxfun(@minus, Vecs2, Vecs*Origindata(:, index));
    [ ~, best_units(index)] = min(Dist);
end 

hits = zeros(size(Vecs,1),1);
for i = 1:datalen, 
	hits(best_units(i)) = hits(best_units(i))+1; 
end
best_index = best_units';
end