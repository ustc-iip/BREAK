function sfa1_step(hdl, arg, step)
% SFA1_STEP a step in the SFA1 algorithm.
%   SFA1_STEP(HDL, ARG, STEPNAME)
%   Do not use this function directly, use SFA_STEP instead.
%
%   See also SFA_STEP
  
  global SFA_STRUCTS
  
  if nargin>2,
    old_step=SFA_STRUCTS{hdl}.step;
    %%% strategy:
    %%%   check step is init->preprocessing->sfa
    %%%   clear step variables
       
    %%% init->preprocessing
    if strcmp(old_step,'init') & strcmp(step,'preprocessing'),
      fprintf('start preprocessing\n');
      SFA_STRUCTS{hdl}.lcov_hdl=lcov_create(size(arg,2));
      SFA_STRUCTS{hdl}.diff_hdl=lcov_create(size(arg,2));

    %%% preprocessing->sfa
    elseif strcmp(old_step,'preprocessing') & strcmp(step,'sfa'),
      global LCOV_STRUCTS
      
      fprintf('close preprocessing\n');
      lcovhdl=SFA_STRUCTS{hdl}.lcov_hdl;
      lcov_fix(lcovhdl);
      SFA_STRUCTS{hdl}.avg0=LCOV_STRUCTS{lcovhdl}.avg;
      SFA_STRUCTS{hdl}.tlen0=LCOV_STRUCTS{lcovhdl}.tlen;
      
      dfhdl=SFA_STRUCTS{hdl}.diff_hdl;

      % perform sfa step
      fprintf('perform slow feature analysis\n');

      sfa_range=SFA_STRUCTS{hdl}.sfa_range;
      if length(sfa_range)==1, sfa_int=1:sfa_range;
      else sfa_int=sfa_range(1):sfa_range(2); end
    
      [SFA_STRUCTS{hdl}.SF,D]= ...
	  eig(LCOV_STRUCTS{dfhdl}.COV_MTX,LCOV_STRUCTS{lcovhdl}.COV_MTX);
      
      D=diag(D);
      [tmp,idx]=sort(D);
      SFA_STRUCTS{hdl}.DSF=D(idx(sfa_int));
      SFA_STRUCTS{hdl}.SF=SFA_STRUCTS{hdl}.SF(:,idx(sfa_int))';


      % clean up
      lcov_clear(lcovhdl);
      SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'lcov_hdl');
      lcov_clear(dfhdl);
      SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'diff_hdl');

      fprintf('SFA1 closed\n');
    elseif ~strcmp(step,old_step),
      warning 'unknown step sequence'
      return
    end
      
    SFA_STRUCTS{hdl}.step=step;
  end

  switch SFA_STRUCTS{hdl}.step,
   case 'preprocessing',
      lcov_update(SFA_STRUCTS{hdl}.lcov_hdl, arg);
      lcov_update(SFA_STRUCTS{hdl}.diff_hdl, timediff(arg, SFA_STRUCTS{hdl}.ax_type));
  end
