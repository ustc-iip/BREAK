function handle=sfa1_create(sfa_range, ax_type, reg_ct)
% SFA1_CREATE Create a linear SFA object.
%   HDL = SFA1_CREATE(SFA_RANGE, AX_TYPE) creates a linear SFA object,
%   referenced by the handle HDL.
%
%   SFA_RANGE is the number of slowly-varying functions to be kept.
%
%   AX_TYPE is the type of derivative approximation to be used. It can be
%   either 'ORD1' (linear approx.) or 'ORD3a' (cubic approx.) (default: 'ORD1')
%
%   See also SFA2_CREATE, SFA_STEP
  
  global SFA_STRUCTS
  
  % init if first call
  if isempty(SFA_STRUCTS),
    SFA_STRUCTS=cell(3,1);
  end
    
  % find empty slot
  handle=-1;
  for i=1:size(SFA_STRUCTS,1)
    if isempty(SFA_STRUCTS{i}),
      handle=i;
      break;
    end
  end
  if handle==-1, handle=size(SFA_STRUCTS,1)+1; end

  if nargin>=2 & (strcmpi(ax_type,'ORD1') | strcmpi(ax_type,'ORD3a')),
    SFA_STRUCTS{handle}.ax_type=ax_type;
  else
    SFA_STRUCTS{handle}.ax_type='ORD1';
  end

  %  reg_ct is the regularization constant (default: 0)
  if nargin>=3,
    SFA_STRUCTS{handle}.reg_ct=reg_ct;
  else
    SFA_STRUCTS{handle}.reg_ct=0;
  end
  
  SFA_STRUCTS{handle}.sfa_range=sfa_range;
  SFA_STRUCTS{handle}.step='init';
  SFA_STRUCTS{handle}.deg=1;
