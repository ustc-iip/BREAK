function ui = crossover(xi, vi, dim, crossoverType, CR)
% Perform crossover between two parents.
%   Parameters:
%   xi                  - the target vector
%                       [vector of 1*dim dimension]
%   vi                  - the donor vector
%                       [vector of 1*dim dimension]
%   dim                 - dimension of the function
%                       [scalar]
%   crossoverType       - type of crossover operators
%                       [ string | 'bin', 'exp']
%   CR                  - crossover rate
%                       [ double | CR is between (0, 1] ]


ui = xi; % init ui

switch crossoverType
    case 'bin'
        % binomial crossover
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        n = randi(dim);
        for j = 1:dim
            if rand <= CR || j == n
                ui(j) = vi(j);
            end
        end
        
    case 'exp'
        % exponential crossover
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        n = randi(dim);
        L = 0;
        while rand <= CR && L < dim
            L = L + 1;
        end
        
        for j = n:(n + L - 1)
            j_n = j;
            if j > dim
                j_n = mod(j, dim);
            end
            ui(j_n) = vi(j_n);
        end 
        
    otherwise
        error('Wrong Crossover Type!');
end

end