function [] = plot_residuals_gmres(A, b, min_error)

[x,~,~,~,residuals] = gmres(A,b,[],1e-13,length(b));
n = size(residuals);
n = n(1);
residuals = residuals(2:n);
n = n -1;
semilogy((1:n), residuals);
hold on
for preconditioner = [0, 1, 2]
    [P, Pb, ~] = cg_preconditioner(A, b, preconditioner);
    f = @(x) P(A,x);
    [x,~,~,~,residuals] = gmres(f,Pb,[],1e-13,length(b));
    
    n = size(residuals);
    n = n(1);
    residuals = residuals(2:n);
    n = n -1;
    semilogy((1:n), residuals);
end
hold off
legend('No prec', 'Jacobi', 'ILU', 'I. Cholesky')
