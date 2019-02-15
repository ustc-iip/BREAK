function pop = update_bound(pop, lb, ub)
%UPDATE Update bound
[popsize, dim] = size(pop);
for i = 1:popsize
    for j = 1:dim
        % first (standard)-method
        if pop(i,j) < lb
            if rand < rand
                pop(i,j) = rand * (ub - lb) + lb;
            else
                pop(i,j) = lb;
            end
        end
        if pop(i,j) > ub
            if rand < rand
                pop(i,j) = rand * (ub - lb) + lb;
            else
                pop(i,j) = ub;
            end
        end
    end
end
end

