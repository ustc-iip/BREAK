function sfa_clear(hdl)
% SFA_CLEAR Clear a SFA object.
%   SFA_CLEAR(HDL) clears the SFA object referenced by HDL and performs a
%   PACK operation.
%
%   See also SFA_CLEARALL
  
  global SFA_STRUCTS
  SFA_STRUCTS{hdl}=[];
  pack
