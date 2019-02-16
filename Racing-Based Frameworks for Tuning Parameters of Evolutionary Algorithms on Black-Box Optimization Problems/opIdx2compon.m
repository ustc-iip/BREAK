function [ m, c, f, cr, np ] = opIdx2compon( x, mutationTypes, crossoverTypes, F, CR, NP )
% Given the index of operator combination, return the index of 
% mutationType,crossoverType,F value,CR value.
%   Parameters
%   ----------
%   x: the index of the operator combination
%   Returns
%   -------
%   m, c, f, cr, np: the index of mutationType, crossoverType, F, CR and NP


x = x - 1;
np =  mod(x, length(NP)) + 1;

x = floor(x / length(NP));
cr =  mod(x, length(CR)) + 1;

x = floor(x / length(CR));
f =  mod(x, length(F)) + 1;

x = floor(x / length(F));
c =  mod(x, length(crossoverTypes)) + 1;

x = floor(x / length(crossoverTypes));
m =  mod(x, length(mutationTypes)) + 1;
