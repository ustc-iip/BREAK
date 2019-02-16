function vi = mutation(x, i, bestIdx, mutationType, F, fit)
% Perform mutation on the parents.
%   Parameters:
%   x                   - genotype of the parents' population
%                       [Matrix of mu*dim dimension]
%   i                   - index of the target vector
%                       [positive integer]
%   bestIdx             - The best index of each generation
%                       [positive integer]
%   MutationType        - Type of mutation operators
%                       [ string | 'rand_1', 'best_1', 'target-to-best_1',
%                       'rand_2', 'best_2','rand_2_dir']
%   F                   - scale factor
%                       [ double | F is between (0, 1] ]
%   fit                 - Fitness values of the current population
%                       [positive scalar]

mu = size(x, 1); % get population size

switch mutationType
    case 'rand_1'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling three vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        c = randi(mu); % random index of x_r3
        while c == i || c == a || c == b
            c = randi(mu);
        end
        vi = x(a, :) + F .* (x(b, :) - x(c, :));
        
    case 'best_1'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling two vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        vi = x(bestIdx, :) + F .* (x(a, :) - x(b, :));
        
    case 'target-to-best_1'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling two vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        vi = x(i, :) + F .* (x(bestIdx, :) - x(i, :)) + F .* (x(a, :) - x(b, :));
        
    case 'rand_2'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling five vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        c = randi(mu); % random index of x_r3
        while c == i || c == a || c == b
            c = randi(mu);
        end
        d = randi(mu); % random index of x_r4
        while d == i || d == a || d == b || d == c
            d = randi(mu);
        end
        e = randi(mu); % random index of x_r5
        while e == i || e == a || e == b || e == c || e == d
            e = randi(mu);
        end
        vi = x(a, :) + F .* (x(b, :) - x(c, :)) + F .* (x(d, :) - x(e, :));
        
    case 'best_2'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling four vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        c = randi(mu); % random index of x_r3
        while c == i || c == a || c == b
            c = randi(mu);
        end
        d = randi(mu); % random index of x_r4
        while d == i || d == a || d == b || d == c
            d = randi(mu);
        end
        vi = x(bestIdx, :) + F .* (x(a, :) - x(b, :)) + F .* (x(c, :) - x(d, :));
        
    case 'rand_2_dir'
        % Reference:
        % Das, Swagatam, and Ponnuthurai Nagaratnam Suganthan.
        % "Differential evolution: a survey of the state-of-the-art."
        % IEEE transactions on evolutionary computation 15.1 (2011): 4-31.
        
        % randomly sampling three vectors
        a = randi(mu); % random index of x_r1
        while a == i
            a = randi(mu);
        end
        b = randi(mu); % random index of x_r2
        while b == i || b == a
            b = randi(mu);
        end
        c = randi(mu); % random index of x_r3
        while c == i || c == a || c == b
            c = randi(mu);
        end
        
        compX = [a, b, c];
        compFit = fit(compX);
        [~, ind] = sort(compFit);  % sort the compFit
        vi = x(compX(ind(1)), :) + 0.5 * F.* (2 * x(compX(ind(1)), :) - ...
            x(compX(ind(2)), :) - x(compX(ind(3)), :));
        
    otherwise
        error('Wrong Mutation Type!')
end

end