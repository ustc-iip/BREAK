function DATA=timediff(DATA, ax_type)
% TIMEDIFF Compute the derivative of a signal
%   DIFF = TIMEDIFF(DATA[, AX_TYPE]) computes the derivative of the
%   signal DATA according to the linear approximation (AX_TYPE=='ORD1',
%   default) or to the cubic approximation (AX_TYPE=='ORD3a').
 
  if nargin<2,
    % first order interpolation
    DATA=filter([1 -1], [1], DATA);
    DATA=DATA(2:size(DATA,1),:);
    return
  end

  if strcmpi(ax_type,'ORD3a'),  
    % interpolation by cubic polynom
    DATA=filter([2 -9 18 -11], [1], DATA)./6;
    DATA=DATA(4:size(DATA,1),:);
  elseif strcmpi(ax_type,'SCD'),
    DATA=filter([1 -2 1], [1], DATA);
    DATA=DATA(3:size(DATA,1),:);
  elseif strcmpi(ax_type,'TRD'),
    DATA=filter([-1 3 -3 1], [1], DATA);
    DATA=DATA(4:size(DATA,1),:);
  else,
    % first order interpolation
    DATA=filter([1 -1], [1], DATA);
    DATA=DATA(2:size(DATA,1),:);
  end
