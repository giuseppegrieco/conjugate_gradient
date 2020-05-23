function [] = plot_residuals_m(A, b, min_error)

[~, ~, ~, ~, residuals] = pcg(A, b, 1e-13,length(b));
n = size(residuals);
n = n(1);
residuals = residuals(2:n);
n = n -1;
semilogy((1:n), residuals);
hold on
for preconditioner = [0, 1, 2]
    [P, Pb, ~] = cg_preconditioner(A, b, preconditioner);
    f = @(x) P(A,x);
    [~, ~, ~, ~, residuals] = pcg(f,Pb,1e-13,length(b));
    
    n = size(residuals);
    n = n(1);
    residuals = residuals(2:n);
    n = n -1;
    semilogy((1:n), residuals);
end
hold off
legend('No prec', 'Jacobi', 'ILU', 'I. Cholesky')
