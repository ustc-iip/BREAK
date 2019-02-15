function sfa2_step(hdl, arg, step)
% SFA2_STEP a step in the SFA2 algorithm.
%   SFA2_STEP(HDL, ARG, STEPNAME)
%   Do not use this function directly, use SFA_STEP instead.
%
%   See also SFA_STEP
  
  global SFA_STRUCTS
  
  if nargin>2,
    old_step=SFA_STRUCTS{hdl}.step;
    %%% check step is init->preprocessing->expansion->sfa
    %%% clear step variables
    
    %%% init->preprocessing
    if strcmp(old_step,'init') & strcmp(step,'preprocessing'),
      fprintf('init preprocessing\n');
      if strcmpi(SFA_STRUCTS{hdl}.pp_type, 'PCA'),
	SFA_STRUCTS{hdl}.lcov_hdl=lcov_create(size(arg,2));
      else % SFA1
	SFA_STRUCTS{hdl}.sfa1_hdl=sfa1_create(SFA_STRUCTS{hdl}.pp_range);
      end
      
    %%% preprocessing->expansion
    elseif strcmp(old_step,'preprocessing') & strcmp(step,'expansion'),
      % close preprocessing step
      fprintf('close preprocessing\n');
      
      if strcmpi(SFA_STRUCTS{hdl}.pp_type, 'PCA'),
	global LCOV_STRUCTS
	cvhdl=SFA_STRUCTS{hdl}.lcov_hdl;
      
	lcov_fix(cvhdl);
	fprintf('whitening and dimensionality reduction\n');
	[SFA_STRUCTS{hdl}.W0,SFA_STRUCTS{hdl}.DW0,SFA_STRUCTS{hdl}.D0]= ...
	    lcov_pca(cvhdl,SFA_STRUCTS{hdl}.pp_range);
	SFA_STRUCTS{hdl}.avg0=LCOV_STRUCTS{cvhdl}.avg;
	SFA_STRUCTS{hdl}.tlen0=LCOV_STRUCTS{cvhdl}.tlen;
	
	%clean up
	lcov_clear(cvhdl);
	SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'lcov_hdl');
	
      else %SFA1
	sfa1_hdl=SFA_STRUCTS{hdl}.sfa1_hdl;
	sfa_step(sfa1_hdl, [], 'sfa');

	SFA_STRUCTS{hdl}.W0=SFA_STRUCTS{sfa1_hdl}.SF;
	SFA_STRUCTS{hdl}.D0=SFA_STRUCTS{sfa1_hdl}.DSF;
	SFA_STRUCTS{hdl}.avg0=SFA_STRUCTS{sfa1_hdl}.avg0;
	SFA_STRUCTS{hdl}.tlen0=SFA_STRUCTS{sfa1_hdl}.tlen0;
	
	%clean up
	sfa_clear(sfa1_hdl);
	SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'sfa1_hdl');
      end
      
      % init expansion step
      fprintf('init expansion step\n');
      insize=SFA_STRUCTS{hdl}.pp_range;
      if length(insize)==2, insize=insize(2)-insize(1)+1; end
      xpsize=SFA_STRUCTS{hdl}.xp_range; %xp_dim(insize);
      SFA_STRUCTS{hdl}.xp_hdl=lcov_create(xpsize);
      SFA_STRUCTS{hdl}.diff_hdl=lcov_create(xpsize);

    %%% expansion->sfa
    elseif strcmp(old_step,'expansion') & strcmp(step,'sfa'),
      % close expansion step
      fprintf('close expansion step\n');
      global LCOV_STRUCTS
      
      % expanded data
      xphdl=SFA_STRUCTS{hdl}.xp_hdl;
      lcov_fix(xphdl)
      SFA_STRUCTS{hdl}.avg1=LCOV_STRUCTS{xphdl}.avg;
      SFA_STRUCTS{hdl}.tlen1=LCOV_STRUCTS{xphdl}.tlen;

      dfhdl=SFA_STRUCTS{hdl}.diff_hdl;

      % perform sfa step
      fprintf('perform slow feature analysis\n');
            
      sfa_range=SFA_STRUCTS{hdl}.sfa_range;
      if length(sfa_range)==1, sfa_int=1:sfa_range;
      else sfa_int=sfa_range(1):sfa_range(2); end
      
      
      [SFA_STRUCTS{hdl}.SF,D]= ...
	  eig(LCOV_STRUCTS{dfhdl}.COV_MTX,LCOV_STRUCTS{xphdl}.COV_MTX);
      
      D=diag(D);
      [tmp,idx]=sort(D);
      SFA_STRUCTS{hdl}.DSF=D(idx(sfa_int));
      SFA_STRUCTS{hdl}.SF=SFA_STRUCTS{hdl}.SF(:,idx(sfa_int))';

      lcov_clear(xphdl);
      SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'xp_hdl');
      lcov_clear(dfhdl);
      SFA_STRUCTS{hdl}=rmfield(SFA_STRUCTS{hdl},'diff_hdl');

      fprintf('SFA2 closed\n');
    elseif ~strcmp(step,old_step),
      warning 'unknown step sequence'
      return
    end
      
    SFA_STRUCTS{hdl}.step=step;
  end

  switch SFA_STRUCTS{hdl}.step,
   case 'preprocessing',
    if strcmpi(SFA_STRUCTS{hdl}.pp_type, 'PCA'),
      lcov_update(SFA_STRUCTS{hdl}.lcov_hdl, arg);
    else %SFA1
      sfa_step(SFA_STRUCTS{hdl}.sfa1_hdl, arg, 'preprocessing');
    end
    
   case 'expansion',
    if isempty(arg), return, end
    % project data and reduce dimensionality
    arg=arg-repmat(SFA_STRUCTS{hdl}.avg0, size(arg,1), 1);
    arg=expansion(hdl, arg*SFA_STRUCTS{hdl}.W0');
    lcov_update(SFA_STRUCTS{hdl}.xp_hdl, arg)
    
    lcov_update(SFA_STRUCTS{hdl}.diff_hdl, timediff(arg, SFA_STRUCTS{hdl}.ax_type));
    
  end
  