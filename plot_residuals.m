function [] = plot_residuals(A, b, min_error)

[x, residuals] = conjugate_gradient(A, b);
n = size(residuals);
n = n(2);
semilogy((1:n), residuals);
hold on
for preconditioner = [0, 1, 2]
    [x, residuals] = conjugate_gradient(A, b, preconditioner);
    n = size(residuals);
    n = n(2);
    semilogy((1:n), residuals);
end
hold off
legend('No prec', 'Jacobi', 'ILU', 'I. Cholesky')
