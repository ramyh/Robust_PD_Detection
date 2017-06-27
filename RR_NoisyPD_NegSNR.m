
clear; clc;
% Generate data
load SpectrumNPD_AWGN_Neg_40.mat
data = SpectrumNPD_AWGN_Neg_40;

X = data(:,1:end-1);
y = data(:,end);

% Standardize features to have mean of 0 and variance of 1
X = standardizeCols(X);

% Add bias variable
[n, d] = size(X); % dimesnions of X
X = [ones(n,1) X];
d = d+1; % number of columns of X


p = 1; % norm
lambdaValues = 10.^[3:-0.2:-1];
lambda = lambdaValues(9);
w = zeros(1, d); % Initialization for the weight vector

% Solving the optimization problem to find the optimal weight vector (w)
cvx_begin
variable w(d)
minimize( norm( X * w - y, p ) + lambda *  norm( w, p )  )
cvx_end

Wsparse = w; % The solution is sparse

threshold = 1e-4;
ind = find(abs(Wsparse)>threshold); % Indices of non-zero elements
Nonzeros = length(ind) % Number of Non-Zero elements
SpectrumNPD_AWGN_Neg_40_Sparse = SpectrumNPD_AWGN_Neg_40(:,ind);
csvwrite('SpectrumNPD_AWGN_Neg_40_Sparse.csv', SpectrumNPD_AWGN_Neg_40_Sparse,1,0);