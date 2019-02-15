function DATA=sfa_execute(hdl, DATA, prj, ncomp)
% SFA_EXECUTE Apply the learned functions to input data.
%   OUT = SFA_EXECUTE(HDL, DATA[, PRJ, NCOMP]) applies the SFA
%   functions learned by the SFA obejct referenced by HDL to the input
%   data DATA and returns their output. (The learning phase has of
%   course to be finished, i.e. the SFA-step 'sfa' has to be completed).
%
%   The execution is completed in 4 steps:
%    1. projection on the input principal components (dimensionality
%    reduction)
%    2. expansion (if necessary)
%    3. projection on the whitened (expanded) space
%    4. projection on the slow functions
%
%   If PRJ is defined and nonzero, the preprocessing step 1 is skipped
%   (for SFA2 objects only).
%
%   If NCOMP is defined, it specifies the number of functions to be used.
%
%   See also SFA_STEP
  
  
  global SFA_STRUCTS
  
  if SFA_STRUCTS{hdl}.deg>=2,
    if ~exist('prj') | prj==0,
      DATA=(DATA-repmat(SFA_STRUCTS{hdl}.avg0,size(DATA,1),1))*SFA_STRUCTS{hdl}.W0';
    end

    DATA=expansion(hdl, DATA);
    DATA=DATA-repmat(SFA_STRUCTS{hdl}.avg1,size(DATA,1),1);
    if ~exist('ncomp'),
      DATA=DATA*SFA_STRUCTS{hdl}.SF';
    else,
      DATA=DATA*SFA_STRUCTS{hdl}.SF(1:ncomp,:)';
    end
    
  else % deg==1
    DATA=(DATA-repmat(SFA_STRUCTS{hdl}.avg0,size(DATA,1),1));

    if isfield(SFA_STRUCTS{hdl},'SFWt'),
      DATA=DATA*SFA_STRUCTS{hdl}.SFWt;
    else
      if ~exist('ncomp'),
	DATA=DATA*SFA_STRUCTS{hdl}.SF';
      else,
	DATA=DATA*SFA_STRUCTS{hdl}.SF(1:ncomp,:)';
      end
    end
  end