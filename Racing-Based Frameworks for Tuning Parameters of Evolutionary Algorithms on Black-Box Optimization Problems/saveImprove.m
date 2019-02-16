function saveImprove( saveImpPath, fileName,  impCnt, evolRate)
% Save escape probability and average evolutionary rate to a file.
%   Parameters:
%   savePath            - The path to save
%                       [string]
%   fileName            - File name
%                       [string]
%   impCnt              - The improved count
%                       [positive scalar]
%   evolRate            - The evolution rate
%                       [positive scalar]


if ~isscalar(impCnt) || ~isscalar(evolRate)
    error('both impCnt and EvolRate should be scalar!');
end

save([saveImpPath, filesep, fileName], 'impCnt', 'evolRate');

end

