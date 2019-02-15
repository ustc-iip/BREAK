function lcov_fix(handle)
% LCOV_FIX Fix a covariance object.
%   LCOV_FIX(HANDLE) Compute the definitive covariance matrix
%   and the average of the covariance object referenced by HANDLE
%   after a series of update operations.
%
%   An update operation following a fix operation is going to
%   lead to unpredictable and wrong results.
%
%   See also LCOV_CREATE, LCOV_PCA.
    
  global LCOV_STRUCTS

  tlen=LCOV_STRUCTS{handle}.tlen;

  LCOV_STRUCTS{handle}.COV_MTX=LCOV_STRUCTS{handle}.COV_MTX/(tlen-1)- ...
      LCOV_STRUCTS{handle}.avg'*LCOV_STRUCTS{handle}.avg/tlen/(tlen-1);

  LCOV_STRUCTS{handle}.avg=LCOV_STRUCTS{handle}.avg/tlen;
