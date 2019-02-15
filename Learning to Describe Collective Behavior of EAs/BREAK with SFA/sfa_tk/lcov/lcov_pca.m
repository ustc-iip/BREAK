function [W,DW,D,kvar]=lcov_pca(handle, dim_range)
% LCOV_PCA Principal Component Analysis on a covariance object.
%   [W,DW,D,kvar] = LCOV_PCA(HANDLE[, DIM_RANGE]) performs PCA _and_ whitening
%   on the covariance object referenced by HANDLE.
%   W is the whitening matrix, DW the dewhitening matrix and D an array
%   containing a list of the eigenvalues. kvar contains the total
%   variance keeped in percent.
%
%   ! LCOV_FIX must have been called _before_ you call this function.
%  
%   If DIM_RANGE is specified, only the first DIM_RANGE components are keeped
%   or the components in the range DIM_RANGE(1)..DIM_RANGE(2).
%
%   See also LCOV_FIX.
  
  global LCOV_STRUCTS

  if nargin<2, dim_range=length(LCOV_STRUCTS{handle}.COV_MTX); end
  if length(dim_range)==1, dim_int=1:dim_range;
  else dim_int=dim_range(1):dim_range(2); end

  [tmp,D,PC]=svd(LCOV_STRUCTS{handle}.COV_MTX);
  %[PC,D]=eig(LCOV_STRUCTS{handle}.COV_MTX);
  
  %reduce the dimensionality
  %[D,idx]=sort(-diag(D));
  %D=real( (-D(dim_int)).^(-0.5) );
  % svd sorts the eigenvalues by itself
  D=diag(D);
  kvar = sum(D(dim_int))/sum(D);
  D=D(dim_int).^(-0.5);
  Dmtx=diag(D);
    
  %PC=PC(:,idx(dim_int))';
  PC=PC(:,dim_int)';
   
  W=Dmtx*PC;
  DW=PC'*inv(Dmtx);
  D=D.^-2;
