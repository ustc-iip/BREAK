function sfa_clearall
% SFA_CLEARALL Clear all SFA objects.
%   SFA_CLEARALL clears all SFA objects and performs a PACK
%   operation. All SFA data will be lost.
%
%   See also SFA_CLEAR
  
  clear global SFA_STRUCTS
  pack
  