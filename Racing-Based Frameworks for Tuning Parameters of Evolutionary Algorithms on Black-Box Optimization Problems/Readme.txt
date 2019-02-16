Two kinds of categorical parameters and three numerical parameters of DE are configured as the candidate set. Concretely, for categorical parameters, 
the mutation operator can be selected from the set {rand/1, best/1, target-to-best/1,best/2, rand/2, rand/2/dir}; the crossover operator can use the 
binomial or exponential methods. As to the numerical parameters, both the scale factor F andthe crossover rate CR are sampled from the range [0; 1] 
with five equal intervals, i.e., F and CR can be chosen from {0.1; 0.3; 0.5; 0.7; 0.9}. Population size NP is chosen from {20, 60, 100, 140, 180}.
Therefore, the total number of parameter configurations is 6*2*5*5*5=1500.

race_F.m executes F-Race, selects the good parameter configurations from 1500 parameter configurations, and records the results.
race_KW.m executes KW-Race, selects the good parameter configurations from 1500 parameter configurations, and records the results.
race_KW_vs_F.m draws the racing curves of KW-Race and F-Race.
race_F_KW.m executes F-KW-Race, selects the good parameter configurations from 1500 parameter configurations, and records the results.
race_F_KW_vs_KW.m draws the racing curves of F-KW-Race and KW-Race.

