function [names] = getsortnames(readpath)
% read raw data, construct image matrix
f = dir([readpath, filesep, '*.mat']);
n = length(f);
count = zeros(1, n);
names = cell(1,n);
for i = 1:n
    t = char(regexp(f(i).name, '\d+', 'match'));
    names{i} = t;
    count(i) = str2double(t);
end
[~, I] = sort(count);
names = names(I);