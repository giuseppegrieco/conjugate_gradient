function [] = plot_residuals_gmres(A, b, min_error)

%generation and plot of gmres results without preconditioner
[~,~,~,~,residuals] = gmres(A,b,[],min_error,length(b));
num_iterations = size(residuals);
num_iterations = num_iterations(1);
residuals = residuals(2:num_iterations);
num_iterations = num_iterations - 1;
semilogy((1:num_iterations), residuals);

%generation and plot of gmres results using preconditioner
hold on
for preconditioner = [0, 1, 2]
    [P, Pb, ~] = cg_preconditioner(A, b, preconditioner);
    f = @(x) P(A,x);
    [~,~,~,~,residuals] = gmres(f,Pb,[],min_error,length(b));
    
    num_iterations = size(residuals);
    num_iterations = num_iterations(1);
    residuals = residuals(2:num_iterations);
    num_iterations = num_iterations -1;
    semilogy((1:num_iterations), residuals);
end
hold off

legend('No prec', 'Jacobi', 'ILU', 'I. Cholesky')
