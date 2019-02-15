function sfa_step(hdl, arg, step)
% SFA_STEP Update a step of the SFA algorithm.
%   SFA_STEP(HLD, DATA[, STEP]) updates the current step of the SFA
%   algorithm. HDL is the handle of an SFA object, DATA contains a chunk of
%   input data (each column a different variable).
%
%   STEP specifies the current SFA step. If not specified, the current
%   step is used. The steps must be given in the right sequence:
%     for SFA1 objects:  'preprocessing', 'sfa'
%     for SFA2 objects:  'preprocessing', 'expansion', 'sfa'
%   Each time a new step is invoked, the previous one is closed, which
%   might take some time.
%
%   Example: suppose you have divided your training data into two chunks,
%   DATA1 and DATA2. Let the number of input dimensions be N. To apply
%   SFA on them write:
%   
%   hdl = sfa2_create(N,xp_dim(N))
%   sfa_step(hdl, DATA1, 'preprocessing')
%   sfa_step(hdl, DATA2)
%   sfa_step(hdl, DATA1, 'expansion')
%   sfa_step(hdl, DATA2)
%   sfa_step(hdl, [], 'sfa')
%   output1 = sfa_execute(hdl, DATA1)
%   output2 = sfa_execute(hdl, DATA2)
%
%   See also SFA1_CREATE, SFA2_CREATE, SFA_EXECUTE
    
  global SFA_STRUCTS
  
  if SFA_STRUCTS{hdl}.deg==1,
    sfa1_step(hdl, arg, step);
  else
    sfa2_step(hdl, arg, step);
  end
