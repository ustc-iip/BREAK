function hdl=sfa_load(filename)
% SFA_LOAD Load a SFA object.
%   HDL = SFA_LOAD(FILENAME) loads the SFA object saved in the file
%   FILENAME and assign to it the handle HDL. The file must have been
%   saved by SFA_SAVE.
%
%   See also SFA_SAVE
  
  global SFA_STRUCTS
  
  % init if first call
  if isempty(SFA_STRUCTS),
    SFA_STRUCTS=cell(3,1);
  end
    
  % find empty slot
  hdl=-1;
  for i=1:size(SFA_STRUCTS,1)
    if isempty(SFA_STRUCTS{i}),
      hdl=i;
      break;
    end
  end
  if hdl==-1, hdl=size(SFA_STRUCTS,1)+1; end

  load(filename);
  SFA_STRUCTS{hdl}=strct;
