function savebestFitAll(type, savepath, block_sum, treatment, func_names, func_num, mutationTypes, crossoverTypes, F, CR, NP, options)


bestFitEachFunc = zeros(block_sum, length(treatment));
fstHitFEsEachFunc = zeros(block_sum, length(treatment));

for opIdx = 1:length(treatment)
    % obtain values of each parameter
    [m, c, f, cr, np] = opIdx2compon(opIdx, mutationTypes, crossoverTypes, F, CR, NP);
    
    if  treatment(opIdx)
        for run_num = 1: block_sum
            
            % read bestFitSoFar.mat
            saveBestPath = [type, filesep, 'conver_trend', filesep, 'dim_', num2str(options.Dim),...
                filesep, func_names{func_num}, filesep, options.AlgoName,  filesep, ...
                [num2str(opIdx), '-', mutationTypes{m}, '-', crossoverTypes{c}, '-F', ...
                num2str(F(f)), '-CR', num2str(CR(cr)), '-NP', num2str(NP(np))], filesep, ...
                'run_', num2str(run_num)];
            
            bestFitSoFarStruct = load([saveBestPath, filesep, 'bestFitSoFar.mat']);
            bestFitSoFar = bestFitSoFarStruct.bestFitSoFar;
            FEsEachGen = bestFitSoFarStruct.FEsEachGen;
            
            % performing the float-point correction (let (f - floor(f) < 1e-8) = 0)
            maskbestFit = (bestFitSoFar - floor(bestFitSoFar) < 1e-8);
            if any(maskbestFit)
                % do the correction
                bestFitSoFar(maskbestFit) = floor(bestFitSoFar(maskbestFit));
            end
            % find the FEs that the algorithm first reached this fitness
            bestFit = bestFitSoFar(end);
            idx = find(bestFitSoFar == bestFit, 1);
            fstHittingFEs = FEsEachGen(idx);
            
            bestFitEachFunc(run_num, opIdx) = bestFit;
            fstHitFEsEachFunc(run_num, opIdx) = fstHittingFEs;
            
        end
    end
end
save([savepath, filesep, 'bestFitEachFunc.mat'], 'bestFitEachFunc');
save([savepath, filesep, 'fstHitFEsEachFunc.mat'], 'fstHitFEsEachFunc');
end