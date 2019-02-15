function res=eta(signal, T)
% ETA Computes the eta value of a signal.
%   ETAVAL = ETA(DATA, T) returns the eta value of the signal DATA in a
%   time interval T time units long.
%   The columns of DATA correspond to different input components.
%   DATA must already be normalized (zero mean and unit variance).

  res=var(timediff(signal));
  res=sqrt(res)*T/(2*pi);
  