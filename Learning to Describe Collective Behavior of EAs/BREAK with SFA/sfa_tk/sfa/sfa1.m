function [y, hdl] = sfa1(x),
% SFA1 Linear Slow Feature Analysis.
%   Y = SFA1(X) performs linear Slow Feature Analysis on the input data
%   X and returns the output signals Y ordered by increasing temporal
%   variation, i.e. the first signal Y(:,1) is the slowest varying one,
%   Y(:,2) the next slowest varying one and so on. The input data have to
%   be organized with each variable on a column and each data point on a
%   row, i.e. X(t,i) is the value of variable nr. i at time t.
%
%   [Y, HDL] = SFA1(X) also returns the handle HDL to the SFA object,
%   which can be used to further analyze the learned functions.
%
%   See also SFA1_CREATE, SFA_STEP, SFA_EXECUTE

n = size(x,2);

  
% create a SFA object
hdl = sfa1_create(n);
% perform the preprocessing step
sfa_step(hdl, x, 'preprocessing');
% close the algorithm
sfa_step(hdl, [], 'sfa');

% compute the output signal
y = sfa_execute(hdl, x);

% clear the SFA object if it is not requested
if nargout<2,
  sfa_clear(hdl);
end
