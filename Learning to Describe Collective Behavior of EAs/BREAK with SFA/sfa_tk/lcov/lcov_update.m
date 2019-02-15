function lcov_update(handle, DATA)
% LCOV_UPDATE Update a covariance object.
%   LCOV_UPDATE(HANDLE, DATA) updates the covariance object
%   referenced by HANDLE with a new chunk of data DATA. DATA
%   must be oriented so that each column is a variable and
%   each row a new measurement.
  
  global LCOV_STRUCTS

  LCOV_STRUCTS{handle}.COV_MTX=LCOV_STRUCTS{handle}.COV_MTX+DATA'*DATA;
  
  LCOV_STRUCTS{handle}.avg=LCOV_STRUCTS{handle}.avg+sum(DATA);
  
  LCOV_STRUCTS{handle}.tlen=LCOV_STRUCTS{handle}.tlen+size(DATA,1);
