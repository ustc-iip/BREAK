function [data_PCA_train, data_PCA_test] = PCAofTrainTest(data_input_train, data_input_test, m)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[~, c]=size(data_input_train);
parfor i=1:c
    Data_adjust_train(:,i)=data_input_train(:,i)-mean(data_input_train(:,i));
    Data_adjust_test(:,i)=data_input_test(:,i)-mean(data_input_train(:,i));
end
fprintf('Compute the Covariance Matrix...\n');
Cov=cov(Data_adjust_train);
fprintf('Covariance Matrix Compute Complete!\n');
fprintf('Compute the Eigenvector and Eigenvalue...\n');
[V, ~]=eig(Cov);
fprintf('Eigenvector and Eigenvalue Compute Complete!\n');
% global RowVector;
RowVector=V(:,c-m+1:c);
data_PCA_train=Data_adjust_train*RowVector;
data_PCA_test=Data_adjust_test*RowVector;
fprintf('PCA Complete!\n');
end