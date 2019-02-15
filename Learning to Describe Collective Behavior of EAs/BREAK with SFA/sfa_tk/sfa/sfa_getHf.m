function [H,f,c]=sfa_getHf(hdl, nr, where)
% SFA_GETHF Return a SFA function as a quadratic form.
%   [H,f,c] = SFA_GETHF(HDL, NR, WHERE) returns function number NR in the
%   sfa object referenced by HDL in the form of a quadratic form
%            q(x) = 1/2*x'*H*x + f'*x + c
%   Of course, this only works if a quadratic expansion was used during
%   training.
%
%   The quadratic form can lie in different spaces, i.e. it can receive
%   as input preprocessed or non-preprocessed vectors. This is specified
%   by setting the argument WHERE. The quadratic form lies
%    - in the preprocessed space for WHERE==0 (e.g. the whitened space if
%      the preprocessing type is PCA)
%    - in the PCA space (i.e. projected on the principal components but
%      not whitened, works only if PCA was used for preprocessing) for
%      WHERE==1
%    - in the input, mean-free space for WHERE==2
%    - in the input space for WHERE==3
%   In general you will need to set WHERE to 2 or 3, but working in the
%   preprocessed spaces can often drastically improve the speed of
%   analysis.
%
%   See also SFA2_CREATE

  global SFA_STRUCTS
  
  %%% check arguments
  if SFA_STRUCTS{hdl}.deg==1,
    error 'sfa_getHf: "hdl" is SFA1-object',
  end
  if where==1 & strcmpi(SFA_STRUCTS{hdl}.pp_type, 'SFA1'),
    error 'sfa_getHf: "hdl" preprocessing type is SFA1'
  end
  if where>3 | where<0,
    error 'sfa_getHf: wrong "where" argument.'
  end
    
  sf=SFA_STRUCTS{hdl}.SF(nr,:);
  c=-SFA_STRUCTS{hdl}.avg1*sf';
  
  pca_dim=SFA_STRUCTS{hdl}.pp_range;
  if length(pca_dim)>1, pca_dim=pca_dim(2)-pca_dim(1); end

  %--- split linear and quadratic part
  % f is linear part
  % H is matrix of the quadratic part
  f=sf(1:pca_dim)';
  H=zeros(pca_dim,pca_dim);
  k=pca_dim;
  for i=1:pca_dim
    for j=1:pca_dim
      if j>i, k=k+1; H(i,j)=sf(k);
      elseif j==i, k=k+1; H(i,j)=2*sf(k);
      else H(i,j)=H(j,i);
      end
    end
  end

  % transform H and f according to 'where'
  if where==1,
    D=diag(SFA_STRUCTS{hdl}.D0.^(-0.5));
    H=D'*H*D;
    f=D'*f;
  elseif where>=2,
    W0=SFA_STRUCTS{hdl}.W0;
    H=W0'*H*W0;
    f=W0'*f;
    
    if where==3,
      avg = SFA_STRUCTS{hdl}.avg0';
      c = 0.5*avg'*H*avg - f'*avg + c;
      f = -H*avg + f;
    end
  end
