function unit_distance = cal_unit_distance( map_size, shape )
%TRAINSOM calculate the distance between each 2 units.
%	size	:(vector) length 2;
%	shape	:(string) 'hexa' or 'rect'
%   Detailed explanation goes here
if length(map_size)~=2
	error('map_size must be a 2-length vector');
end;

if (~strcmp(shape,'hexa'))&&(~strcmp(shape,'rect'))
	error('shape should be hexa or rect');
end;

num_units = prod(map_size);
coord_units = zeros(num_units, 2);

coord_units(:, 1) = floor((0:(num_units-1))/map_size(1));
coord_units(:, 2) = mod((0:(num_units-1)), map_size(1));
 
if strcmp(shape, 'hexa')
	index = 2:2:map_size(1);
	for i = 0:map_size(2)-1
		coord_units(index, 1) = coord_units(index, 1) +0.5;
		index = index + map_size(1);
	end;

	coord_units(:,2) = coord_units(:,2)*sqrt(0.75); 
end;

unit_distance = zeros(num_units, num_units);

for i= 1: num_units,
	unit_distance(:,i) = sqrt(sum((bsxfun(@minus,coord_units,coord_units(i,:))).^2,2));
end;

end

