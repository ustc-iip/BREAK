function sfa_save(hdl, filename)
% SFA_SAVE Save a SFA object.
%   SFA_SAVE(HDL, FILENAME) saves the SFA object referenced by HDL to
%   FILENAME with the variable name 'strct'.
%
%   See also SFA_LOAD
  
  global SFA_STRUCTS
  
  %sfa_clear_fastexc(hdl);
  strct=SFA_STRUCTS{hdl};
  save(filename,'strct');
