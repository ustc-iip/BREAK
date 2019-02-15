function res=leta(DATA,T)
% LETA Compute the eta values of long data signals.
%   ETAVAL = LETA(DATA, T) updates the internal structures and returns
%   the eta values of the data signals seen so far.
%   The input signal does not need to be normalized.
%
%   LETA without arguments clears the global structures.
%
%   example:    
%   % clear the global structure
%   leta
%   % first data chunck
%   leta(DATA1,1)
%   % ...
%   % last data chunck
%   eta_values = leta(DATAN,1)
%
%   See also ETA
  
  if nargin==0,
    clear global LETA_VAR LETA_TLEN LETA_MEAN LETA_DIFF2 LETA_DIFF_TLEN
    return
  end

  global LETA_VAR LETA_TLEN LETA_MEAN LETA_DIFF2 LETA_DIFF_TLEN
  
  if isempty(LETA_VAR),
    LETA_MEAN=zeros(1,size(DATA,2));
    LETA_VAR=zeros(1,size(DATA,2));
    LETA_TLEN=0;
    LETA_DIFF2=zeros(1,size(DATA,2));
    LETA_DIFF_TLEN=0;
  end
  
  LETA_MEAN=LETA_MEAN+sum(DATA);
  LETA_VAR=LETA_VAR+sum(DATA.^2);
  LETA_TLEN=LETA_TLEN+size(DATA,1);

  diff = timediff(DATA);
  LETA_DIFF2=LETA_DIFF2+sum(diff.^2);
  LETA_DIFF_TLEN = LETA_DIFF_TLEN+size(diff,1);

  var = LETA_VAR/(LETA_TLEN-1)-(LETA_MEAN/LETA_TLEN).^2;
  delta = (var.^-1).*(LETA_DIFF2/LETA_DIFF_TLEN);
  res=sqrt(delta)*T/(2*pi);
