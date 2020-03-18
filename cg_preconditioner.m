function [P, Pb, Px] = cg_preconditioner(A, b, type)

%function [P, Pb, Px] = cg_preconditioner(A, b, type)
%
% This function is used to obtain function to use as preconditioner in
% conjugate gradient algorithm.
%
% Input:
%
% - A the coefficient matrix;
%
% - b the known terms vector;
%
% - type (integer between 0 and 2) to choose which preconditioner uses:
%       = 0 for Jacobi preconditioner;
%       = 1 for Incomplete LU preconditioner;
%       = 2 for Incomplete Cholesky preconditioner.
%
% Output:
%
% - P (function(A, x)): computes matrix vector product with preconditioner;
%
% - Pb (real column vector): computes the known terms vector of
% preconditioned system;
%
% - Px (function(x)): allows to obtain the solution of initial system from
% the solution of preconditioned system.
%
%
%{
 =======================================
 Authors: Giuseppe Grieco, Mattia Sangermano
 Date: 03-15-20
 =======================================
%}

switch (type)
    % Jacobi preconditioner %
    case 0
        n = size(A);
        n = n(1);
        C = sqrt(spdiags(diag(A), 0, n, n));
        P = @(A, x) C \ (A * (C' \ x));
        Pb = C \ b;
        Px = @(x) C' \ x;
    % Incomplete LU preconditioner %
    case 1
        [L, U] = ilu(A);
        P = @(A, x) U \ (L \ (A * x));
        Pb = (L * U) \ b;
        Px = @(x) x;
    % Cholesky preconditioner %
    case 2
        L = ichol(A);
        P = @(A, x) L \ (A * (L' \ x));
        Pb = L \ b;
        Px = @(x) L' \ x;
    otherwise
        error("Type not supported, type 0 for diagonal, 1 for incomplete LU or 2 for incomplete Cholesky")
end