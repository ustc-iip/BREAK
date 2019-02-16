function [p_f, Q, Rmean, control_id, p_corrected, reject, best_ids] = ...
    f_conover_control(groups, flag, alpha)
% Perfrom F Test followed by Connover post-hoc precedure and adjusted
% p-values procedure.
% Parameters:
% groups  - The input data
%           [matrix]  row is each measure, column is each group
%           [cell array]  each element of cell array is a group
% flag    - The flag to set the controlled group
%           [0 or 1]
%           if flag == 0, the minimum Rmean is set to the control;
%           if flag == 1, the maximum Rmean is set to the control;
% alpha   - significance level or FWER
%           [float]  0.05 is default


% first perform the F test as the omnibus test
[p_f, Q, Rm, Rmean, ranked] = f_test(groups);

[n, k] = size(groups);

if(p_f < alpha)
    if flag == 0
        [R_control, control_id] = min(Rm);
    elseif flag == 1
        [R_control, control_id] = max(Rm);
    end
    R_all = 1:k;
    R_all(control_id) = [];  % delete controlled group
    R_rest = R_all;
    
    % perform Conover post-hoc precedure
    R_diff = abs(Rm(R_rest) - R_control) ./ sqrt(2*n*(1-Q/(n*(k-1)))* ...
        (sum(sum(ranked.^2))  - n * k * (k + 1).^2 / 4) / ((n-1)*(k-1)));
    
    % using student-t distribution to calculate p-value
    df = (n-1)*(k-1);
    p_uncorrected = 1 - tcdf(R_diff, df);
    
    % adjusted p-values using Holm procedure
    del_control = [1:(control_id-1) (control_id+1):k];
    [pc_uncorrected, ind] = sort(p_uncorrected, 'ascend');
    pc_corrected = pc_uncorrected .* (k - (1:(k-1)));
    p_corrected = zeros(size(pc_corrected));
    p_corrected(ind) = pc_corrected;
    reject = (p_corrected <= alpha);
    best_ids = [control_id del_control(reject == 0)];
        
    p_corrected(p_corrected > 1) = 1;
else
    control_id = 0;
    p_corrected = 1;
    reject = 0;
    best_ids = 1:k;
end
end
