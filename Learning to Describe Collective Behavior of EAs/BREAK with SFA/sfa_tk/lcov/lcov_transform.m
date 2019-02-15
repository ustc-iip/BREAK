function lcov_transform(handle, A)
% LCOV_TRANSFORM Transform a covariance object.
%   LCOV_TRANSFORM(HANDLE, A)  Transforms the covariance object
%   referenced by HANDLE according to the linear function A.
%
%   ! LCOV_FIX must have been called _before_ you call this function.
 %
%   See also LCOV_FIX.

  global LCOV_STRUCTS

  LCOV_STRUCTS{handle}.avg=LCOV_STRUCTS{handle}.avg*A';
  LCOV_STRUCTS{handle}.COV_MTX = A*LCOV_STRUCTS{handle}.COV_MTX*A';