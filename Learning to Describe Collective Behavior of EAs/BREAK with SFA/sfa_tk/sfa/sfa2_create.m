function handle=sfa2_create(pp_range, sfa_range, pp_type, ax_type, reg_ct)
% SFA2_CREATE Create an expanded SFA object.
%   HDL = SFA2_CREATE(PP_RANGE, SFA_RANGE[, PP_TYPE, AX_TYPE]) creates an
%   expanded SFA object, referenced by the handle HDL.
%
%   PP_RANGE is the number of dimensions to be kept after the
%   preprocessing step. Two preprocessing types can be chosen by setting
%   PP_TYPE to either 'PCA' (principal components analysis) or 'SFA1'
%   (linear SFA, default).
%
%   SFA_RANGE is the number of slowly-varying functions to be kept.
%
%   AX_TYPE is the type of derivative approximation to be used. It can be
%   wither 'ORD1' (linear approx.) or 'ORD3a' (cubic approx.) (default: 'ORD1')
%
%   See also SFA1_CREATE, SFA_STEP
  
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
  
  SFA_STRUCTS{handle}.pp_range=pp_range;

  if length(pp_range)==2,
    pp_dim=pp_range(2)-pp_range(1)+1;
  else
    pp_dim=pp_range;
  end
  SFA_STRUCTS{handle}.xp_range=xp_dim(pp_dim);

  SFA_STRUCTS{handle}.sfa_range=sfa_range;

  if nargin>=3 & (strcmpi(pp_type,'SFA1') | strcmpi(pp_type,'PCA')),
    SFA_STRUCTS{handle}.pp_type=pp_type;
  else
    SFA_STRUCTS{handle}.pp_type='SFA1';
  end

  if nargin>=4, % & (strcmpi(ax_type,'ORD1') | strcmpi(ax_type,'ORD3a')),
    SFA_STRUCTS{handle}.ax_type=ax_type;
  else
    SFA_STRUCTS{handle}.ax_type='ORD1';
  end

  %  reg_ct is the regularization constant (default: 0)
  if nargin>=5,
    SFA_STRUCTS{handle}.reg_ct=reg_ct;
  else
    SFA_STRUCTS{handle}.reg_ct=0;
  end

  SFA_STRUCTS{handle}.step='init';
  SFA_STRUCTS{handle}.deg=2;


