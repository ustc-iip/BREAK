function Map = creatsom(map_size, dim, shape, range)
%CREATSOM  creat(initial) a som Map by unifrnd the reference vecotrs in it.

% Input and output arguments ([]'s are optional):
%	Map  		 	: (struct) return the updated map
%	map_size        : (vector) length 2
%   dim				: (scalar) Map.ref_vects dimension
%   shape   		: (string) 'hexa' or 'rect'.
%	range 			: (vector) range of the ref_vects.

% 
%   Detailed explanation goes here
%


%narginchk(2, 4);  % check input arguments. if less than 2 or more than 4, error.

Map.ref_vects = unifrnd(range(1), range(2), prod(map_size), dim);
Map.how2train = 'initial';
Map.dim = dim;
Map.map_size = map_size;
Map.radius = [];
Map.shape = shape;

end