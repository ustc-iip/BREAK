function handle=lcov_create(dim)
% LCOV_CREATE Create a new covariance object.
%   HANDLE = LCOV_CREATE(DIM) creates a covariance object that
%   contains a matrix of dimension DIM and returns a "reference"
%   to it.
%
%   The covairance object is stored in the global cell array
%   LCOV_STRUCTS{HANDLE}
%
%   See also LCOV_UPDATE, LCOV_CLEAR.
  
  global LCOV_STRUCTS
  
  % init if first call
  if isempty(LCOV_STRUCTS),
    LCOV_STRUCTS=cell(3,1);
  end

  % find empty slot
  handle=-1;
  for i=1:size(LCOV_STRUCTS,1)
    if isempty(LCOV_STRUCTS{i}),
      handle=i;
      break;
    end
  end
  if handle==-1, handle=size(LCOV_STRUCTS,1)+1; end
  
  LCOV_STRUCTS{handle}.COV_MTX=zeros(dim);
  LCOV_STRUCTS{handle}.avg=zeros(1,dim);
  LCOV_STRUCTS{handle}.tlen=0;
  