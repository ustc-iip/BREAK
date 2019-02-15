function dim=xp_dim( in_dim ),
% XP_DIM Compute the dimension of a vector expanded in the space of
% polynomials of 2nd degree.
%   DIM = XP_DIM(IN_DIM) returns the dimension of a vector expanded in
%   the space of polynomials of second degree if its dimension is IN_DIM.
  
  dim=in_dim+(in_dim+1)*in_dim/2;
