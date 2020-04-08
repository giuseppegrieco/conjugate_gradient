function [x, residuals, time_prec,time_alg] = conjugate_gradient(A, b, preconditioner, min_error)
%function [x, residuals] = conjugate_gradient(A, b, preconditioner, min_error)
%
% This function is used to solve the linear system using Conjugate Gradient algorithm 
%
% Input:
%
% - A the coefficient matrix;
%
% - b the known terms vector;
%
% - preconditioner (integer between 0 and 2) to choose which preconditioner to use:
%       = 0 for Jacobi preconditioner;
%       = 1 for Incomplete LU preconditioner;
%       = 2 for Incomplete Cholesky preconditioner.
%
% Output:
%
% - x (real column vector): the solution of the system;
%
% - residuals (real column vector): residuals generated during the
% execution of Conjugate Gradient algorithm.
%
%
%{
 =======================================
 Authors: Mattia Sangermano, Giuseppe Grieco
 Date: 03-18-20
 =======================================
%}
t_prec = tic();
if ~exist('min_error', 'var')
    min_error = 1e-13;
end

if exist('preconditioner', 'var')
    [P, Pb, Px] = cg_preconditioner(A, b, preconditioner);
    b = Pb;
end
time_prec = toc(t_prec);
t_alg = tic();
N = length(b);
x = zeros(size(b));
r = b;
p = r;
residual = r' * r;
norm_b = norm(b);

best_solution = x;
min_residual = sqrt(residual) / norm_b;
min_iter = 1;

residuals = zeros(N);
for i = 1:(N)
    % pre compute it to re-use in differents places %
    if ~exist('P', 'var')
        Ap_n = A * p;
    else
        Ap_n = P(A, p);
    end

    % Step length %
    a_n = residual / (p' * Ap_n);
    % Approximate solution %
    x_n = x + a_n * p;
    % Residual %
    r_n = r - a_n * Ap_n; 

    residual = r_n' * r_n;

    % Improvement this step %
    B_n = residual / (r' * r);
    % Search direction %
    p_n = r_n + B_n * p;

    % Updates old variables %
    x = x_n;
    p = p_n;
    r = r_n;

    % Checks if method converged %
    relative_residual = sqrt(residual) / norm_b;
    if relative_residual < min_residual
        best_solution = x_n;
        min_residual = relative_residual;
        min_iter = i;
    end
    residuals(i) = relative_residual;
    if (relative_residual < min_error) || (i == N)
        fprintf("Conjugate gradient converged at iteration %d to a solution with relative residual %.1E. \n", i, relative_residual);
        fprintf("The iterate returned (number %d) has relative residual %.1E.\n", min_iter, min_residual);
        break;
    end
end
residuals = residuals(1:i);

time_alg = toc(t_alg);
x = best_solution;
if exist('preconditioner', 'var')
    x = Px(x);
end