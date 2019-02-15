function [y, hdl] = sfa2(x),
% SFA2 Expanded Slow Feature Analysis.
%   Y = SFA2(X) performs expanded Slow Feature Analysis on the input data
%   X and returns the output signals Y ordered by increasing temporal
%   variation, i.e. the first signal Y(:,1) is the slowest varying one,
%   Y(:,2) the next slowest varying one and so on. The input data have to
%   be organized with each variable on a column and each data point on a
%   row, i.e. X(t,i) is the value of variable nr. i at time t.
%
%   [Y, HDL] = SFA2(X) also returns the handle HDL to the SFA object,
%   which can be used to further analyze the learned functions.
%
%   The function space in which the input signal is expanded is by
%   default the space of all polynoms of degree 2. To change it, you have
%   to overwrite the functions EXPANSION and XP_DIM (cf. the online
%   documentation).
%
%   See also SFA2_CREATE, SFA_STEP, SFA_EXECUTE
  
n = size(x,2);  
  
% create a SFA object
hdl = sfa2_create(n, xp_dim(n), 'PCA');
% perform the preprocessing step
sfa_step(hdl, x, 'preprocessing');
% perform the expansion step
sfa_step(hdl, x, 'expansion');
% close the algorithm
sfa_step(hdl, [], 'sfa');

% compute the output signal
y = sfa_execute(hdl, x);

% clear the SFA object if it is not requested
if nargout<2,
  sfa_clear(hdl);
end
