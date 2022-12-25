# Conjugate Gradient and Preconditioners in MATLAB

This repository contains the implementation of the conjugate gradient (CG) method and three preconditioners (Jacobi, Incomplete LU, and Incomplete Cholesky) in MATLAB.

## Conjugate Gradient Method

The conjugate gradient (CG) method is an iterative algorithm for solving linear systems of equations of the form `Ax=b`, where `A` is a symmetric positive definite matrix. It is particularly useful when the matrix `A` is large and sparse, as it can converge faster than direct methods such as LU decomposition.

## Preconditioners

Preconditioners are techniques used to improve the convergence of iterative methods such as the conjugate gradient (CG) method. They operate by transforming the original system `Ax=b` into a new system `M^{-1}Ax=M^{-1}b`, where `M` is a preconditioner matrix. The choice of `M` can significantly affect the convergence of the CG method.

There are many different types of preconditioners, and the best one to use depends on the properties of the matrix `A` and the problem at hand. The preconditioners included are:

- Jacobi preconditioner: Uses the diagonal elements of the matrix `A` to construct the preconditioner matrix `M`.
- Incomplete LU (ILU) preconditioner: Uses an incomplete factorization of the matrix `A` to construct the preconditioner matrix `M`.
- Incomplete Cholesky (IC) preconditioner: Also uses an incomplete factorization of the matrix `A` to construct the preconditioner matrix `M`.
