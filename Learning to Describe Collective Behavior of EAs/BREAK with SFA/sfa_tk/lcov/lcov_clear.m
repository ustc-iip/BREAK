function lcov_clear(handle)
% LCOV_CLEAR Delete a covariance object.
%   LCOV_CLEAR(HANDLE) deletes the covariance object referenced
%   by HANDLE. After that, the Matlab function PACK is called.
%
%   See also LCOV_CLEARALL, LCOV_CREATE.

  global LCOV_STRUCTS

  LCOV_STRUCTS{handle}=[];
  pack
