function lcov_clearall()
% LCOV_CLEAR Delete all covariance objects.
%   LCOV_CLEARALL() deletes all covariance objects created by
%   LCOV_CREATE. After that, the Matlab function PACK is called.
%
%   See also LCOV_CLEAR, LCOV_CREATE.

  clear global LCOV_STRUCTS
  pack
